/******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2015-2026 Baldur Karlsson
 * Copyright (c) 2014 Crytek
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

// win32_libentry.cpp : Defines the entry point for the DLL
#include <tchar.h>
#include <windows.h>
#include <tlhelp32.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include "common/common.h"
#include "core/core.h"
#include "hooks/hooks.h"
#include "strings/string_utils.h"

// ---------------------------------------------------------------------------
// Self-dump on crash.
//
// Cross-process dumpers cannot read the target process: WER produced a crash report but no
// dump, ProcDump never fired, and CDB's .dump returned 0x80070005 - while an unprotected
// process using the exact same LocalDumps configuration dumps fine. Only the process itself
// can dump itself, so the handlers are installed here, inside the injected DLL.
//
// These paths deliberately avoid the RenderDoc logger, which may be locked by the crashing
// thread; plain Win32 appends are used instead so that a dump can never be lost to a deadlock.
// ---------------------------------------------------------------------------

struct SelfDumpExceptionInfo
{
  DWORD ThreadId;
  PEXCEPTION_POINTERS ExceptionPointers;
  BOOL ClientPointers;
};

typedef BOOL(WINAPI *pfnMiniDumpWriteDump)(HANDLE hProcess, DWORD ProcessId, HANDLE hFile,
                                           DWORD DumpType, void *ExceptionParam,
                                           void *UserStreamParam, void *CallbackParam);

static const DWORD SELFDUMP_TYPE = 0x00000000 |  // MiniDumpNormal
                                   0x00000004 |  // MiniDumpWithHandleData
                                   0x00000020 |  // MiniDumpWithUnloadedModules
                                   0x00000040 |  // MiniDumpWithIndirectlyReferencedMemory
                                   0x00001000;   // MiniDumpWithThreadInfo

static volatile LONG g_SelfDumpInProgress = 0;
static volatile LONG g_SelfDumpNotes = 0;

static rdcstr SelfDumpBasePath()
{
  // Preferred: an explicit directory from the launcher, so that all artifacts of one run land
  // together. The variable is inherited by the target process through CreateProcess.
  char env[MAX_PATH] = {0};
  DWORD envLen = GetEnvironmentVariableA("RDC_SELFDUMP_DIR", env, MAX_PATH);
  if(envLen > 0 && envLen < MAX_PATH)
  {
    rdcstr dir = env;
    if(!dir.empty() && dir.back() != '\\')
      dir += "\\";
    char pidbuf[32] = {0};
    _snprintf_s(pidbuf, sizeof(pidbuf), _TRUNCATE, "selfdump_%lu", GetCurrentProcessId());
    return dir + pidbuf;
  }

  rdcstr path = rdcstr(RDCGETLOGFILE());

  if(path.empty())
  {
    wchar_t tmp[MAX_PATH] = {0};
    if(GetTempPathW(MAX_PATH, tmp) > 0)
      path = StringFormat::Wide2UTF8(tmp) + "RenderTest-crash";
    else
      path = "C:\\RenderTest-crash";
  }

  return path;
}

static void SelfDumpNote(const char *fmt, ...)
{
  if(InterlockedIncrement(&g_SelfDumpNotes) > 60)
    return;

  char line[512] = {0};
  va_list args;
  va_start(args, fmt);
  vsnprintf_s(line, sizeof(line) - 4, _TRUNCATE, fmt, args);
  va_end(args);

  size_t len = strlen(line);
  line[len++] = '\r';
  line[len++] = '\n';
  line[len] = 0;

  rdcwstr wpath = StringFormat::UTF82Wide(SelfDumpBasePath() + ".crash.txt");
  HANDLE h = CreateFileW(wpath.c_str(), FILE_APPEND_DATA, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
                         OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
  if(h == INVALID_HANDLE_VALUE)
    return;

  DWORD written = 0;
  WriteFile(h, line, (DWORD)len, &written, NULL);
  CloseHandle(h);
}

static bool SelfDumpIsInNtdll(const void *addr)
{
  const uint8_t *base = (const uint8_t *)GetModuleHandleA("ntdll.dll");
  if(!base || !addr)
    return false;

  const IMAGE_DOS_HEADER *dos = (const IMAGE_DOS_HEADER *)base;
  if(dos->e_magic != IMAGE_DOS_SIGNATURE)
    return false;

  const IMAGE_NT_HEADERS *nt = (const IMAGE_NT_HEADERS *)(base + dos->e_lfanew);
  if(nt->Signature != IMAGE_NT_SIGNATURE)
    return false;

  const uint8_t *p = (const uint8_t *)addr;
  return p >= base && p < base + nt->OptionalHeader.SizeOfImage;
}

// --- raw, unwind-free crash dump -------------------------------------------------------------
//
// On the target, MiniDumpWriteDump fails with ERROR_NOACCESS (0x800703E6, Win32 998): the fault
// is inside ntdll's stack-unwind code, and the minidump writer has to unwind the same stacks, so
// it trips over the same corrupted state. Everything below reads only the faulting thread's
// registers, its stack and the module list, so it cannot fail the same way.

struct SelfDumpModuleEntry
{
  uint64_t base;
  uint64_t size;
  wchar_t name[MAX_MODULE_NAME32 + 1];
};

static SelfDumpModuleEntry g_SelfDumpModules[512];
static int g_SelfDumpModuleCount = 0;

static void SelfDumpRawWrite(HANDLE h, const char *fmt, ...)
{
  char line[1024];
  va_list args;
  va_start(args, fmt);
  int len = _vsnprintf_s(line, sizeof(line), _TRUNCATE, fmt, args);
  va_end(args);

  if(len < 0)
    len = (int)strlen(line);

  DWORD written = 0;
  WriteFile(h, line, (DWORD)len, &written, NULL);
}

static void SelfDumpCollectModules()
{
  g_SelfDumpModuleCount = 0;

  HANDLE snap =
      CreateToolhelp32Snapshot(TH32CS_SNAPMODULE | TH32CS_SNAPMODULE32, GetCurrentProcessId());
  if(snap == INVALID_HANDLE_VALUE)
    return;

  MODULEENTRY32W me;
  RDCEraseMem(&me, sizeof(me));
  me.dwSize = sizeof(me);

  if(Module32FirstW(snap, &me))
  {
    do
    {
      if(g_SelfDumpModuleCount >= 512)
        break;

      SelfDumpModuleEntry &e = g_SelfDumpModules[g_SelfDumpModuleCount++];
      e.base = (uint64_t)(uintptr_t)me.modBaseAddr;
      e.size = (uint64_t)me.modBaseSize;
      memcpy(e.name, me.szModule, sizeof(e.name));
      e.name[MAX_MODULE_NAME32] = 0;
    } while(Module32NextW(snap, &me));
  }

  CloseHandle(snap);
}

static const SelfDumpModuleEntry *SelfDumpFindModule(uint64_t addr, uint64_t *offset)
{
  for(int i = 0; i < g_SelfDumpModuleCount; i++)
  {
    const SelfDumpModuleEntry &e = g_SelfDumpModules[i];
    if(addr >= e.base && addr < e.base + e.size)
    {
      if(offset)
        *offset = addr - e.base;
      return &e;
    }
  }

  return NULL;
}

static bool SelfDumpRangeReadable(uint64_t addr, size_t len){
  uint64_t at = addr;
  const uint64_t end = addr + len;

  while(at < end)
  {
    MEMORY_BASIC_INFORMATION mbi;
    if(VirtualQuery((LPCVOID)(uintptr_t)at, &mbi, sizeof(mbi)) != sizeof(mbi))
      return false;

    if(mbi.State != MEM_COMMIT || (mbi.Protect & (PAGE_NOACCESS | PAGE_GUARD)) != 0)
      return false;

    at = (uint64_t)(uintptr_t)mbi.BaseAddress + mbi.RegionSize;
  }

  return true;
}

// Attribute an address to a loaded module for logging; collects the module list on first use.
static void SelfDumpDescribeAddress(uint64_t addr, char *out, size_t outLen)
{
  static volatile LONG collected = 0;
  if(InterlockedCompareExchange(&collected, 1, 0) == 0)
    SelfDumpCollectModules();

  uint64_t offset = 0;
  const SelfDumpModuleEntry *m = SelfDumpFindModule(addr, &offset);

  if(m)
    _snprintf_s(out, outLen, _TRUNCATE, "%ls+0x%llx", m->name, (unsigned long long)offset);
  else
    _snprintf_s(out, outLen, _TRUNCATE, "<no module>");
}

static void SelfDumpWriteRaw(const char *tag, EXCEPTION_POINTERS *ex)
{
  rdcstr path = SelfDumpBasePath() + "." + tag + ".raw.txt";
  rdcwstr wpath = StringFormat::UTF82Wide(path);

  HANDLE h =
      CreateFileW(wpath.c_str(), GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
  if(h == INVALID_HANDLE_VALUE)
  {
    SelfDumpNote("%s: raw dump failed - CreateFileW error %lu", tag, GetLastError());
    return;
  }

  SelfDumpRawWrite(h, "=== raw crash dump ===\r\n");
  SelfDumpRawWrite(h, "tag=%s pid=%lu tid=%lu\r\n", tag, GetCurrentProcessId(), GetCurrentThreadId());

  if(ex && ex->ExceptionRecord)
  {
    const EXCEPTION_RECORD *er = ex->ExceptionRecord;
    SelfDumpRawWrite(h, "exception: code=0x%08lx flags=0x%08lx address=%p params=%lu\r\n",
                     er->ExceptionCode, er->ExceptionFlags, er->ExceptionAddress,
                     er->NumberParameters);

    for(DWORD i = 0; i < er->NumberParameters && i < EXCEPTION_MAXIMUM_PARAMETERS; i++)
      SelfDumpRawWrite(h, "  param[%lu]=0x%016llx\r\n", i,
                       (unsigned long long)er->ExceptionInformation[i]);

    if(er->ExceptionCode == 0xC0000005 && er->NumberParameters >= 2)
    {
      const char *kind = "read";
      if(er->ExceptionInformation[0] == 1)
        kind = "write";
      else if(er->ExceptionInformation[0] == 8)
        kind = "execute";

      SelfDumpRawWrite(h, "  access violation: %s at 0x%016llx\r\n", kind,
                       (unsigned long long)er->ExceptionInformation[1]);
    }
  }

  CONTEXT *ctx = ex ? ex->ContextRecord : NULL;

  SelfDumpCollectModules();

  if(ctx)
  {
    SelfDumpRawWrite(h, "context: rip=%016llx rsp=%016llx rbp=%016llx eflags=%08lx\r\n",
                     (unsigned long long)ctx->Rip, (unsigned long long)ctx->Rsp,
                     (unsigned long long)ctx->Rbp, ctx->EFlags);
    SelfDumpRawWrite(h,
                     "regs: rax=%016llx rbx=%016llx rcx=%016llx rdx=%016llx\r\n"
                     "      rsi=%016llx rdi=%016llx r8 =%016llx r9 =%016llx\r\n"
                     "      r10=%016llx r11=%016llx r12=%016llx r13=%016llx\r\n"
                     "      r14=%016llx r15=%016llx\r\n",
                     (unsigned long long)ctx->Rax, (unsigned long long)ctx->Rbx,
                     (unsigned long long)ctx->Rcx, (unsigned long long)ctx->Rdx,
                     (unsigned long long)ctx->Rsi, (unsigned long long)ctx->Rdi,
                     (unsigned long long)ctx->R8, (unsigned long long)ctx->R9,
                     (unsigned long long)ctx->R10, (unsigned long long)ctx->R11,
                     (unsigned long long)ctx->R12, (unsigned long long)ctx->R13,
                     (unsigned long long)ctx->R14, (unsigned long long)ctx->R15);

    uint64_t ripOffset = 0;
    const SelfDumpModuleEntry *ripMod = SelfDumpFindModule((uint64_t)ctx->Rip, &ripOffset);
    if(ripMod)
      SelfDumpRawWrite(h, "rip in module: %ls + 0x%llx\r\n", ripMod->name,
                       (unsigned long long)ripOffset);
  }

  SelfDumpRawWrite(h, "\r\n=== modules (%d) ===\r\n", g_SelfDumpModuleCount);
  for(int i = 0; i < g_SelfDumpModuleCount; i++)
    SelfDumpRawWrite(h, "%016llx %016llx %ls\r\n", (unsigned long long)g_SelfDumpModules[i].base,
                     (unsigned long long)g_SelfDumpModules[i].size, g_SelfDumpModules[i].name);

  if(ctx)
  {
    const uint64_t sp = (uint64_t)ctx->Rsp;
    const size_t window = 2048;

    SelfDumpRawWrite(h, "\r\n=== stack window [rsp, rsp+0x%zx) ===\r\n", window);

    if(SelfDumpRangeReadable(sp, window))
    {
      const uint8_t *p = (const uint8_t *)(uintptr_t)sp;
      for(size_t row = 0; row < window; row += 16)
      {
        char hex[3 * 16 + 1];
        for(size_t c = 0; c < 16; c++)
          _snprintf_s(hex + c * 3, 4, _TRUNCATE, "%02x ", p[row + c]);
        hex[3 * 16] = 0;

        SelfDumpRawWrite(h, "%016llx  %s\r\n", (unsigned long long)(sp + row), hex);
      }
    }
    else
    {
      SelfDumpRawWrite(h, "(unreadable)\r\n");
    }

    SelfDumpRawWrite(h, "\r\n=== stack scan (return-address candidates) ===\r\n");

    const size_t scanLen = 256 * 1024;
    size_t at = 0;

    while(at < scanLen)
    {
      const uint64_t addr = sp + at;

      MEMORY_BASIC_INFORMATION mbi;
      if(VirtualQuery((LPCVOID)(uintptr_t)addr, &mbi, sizeof(mbi)) != sizeof(mbi))
        break;

      const uint64_t regionEnd = (uint64_t)(uintptr_t)mbi.BaseAddress + mbi.RegionSize;
      size_t next = (size_t)(regionEnd - sp);
      if(next <= at)
        next = at + 4096;

      if(!SelfDumpRangeReadable(addr, sizeof(uint64_t)))
      {
        at = next;
        continue;
      }

      size_t limit = next;
      if(limit > scanLen)
        limit = scanLen;

      for(size_t o = at; o + sizeof(uint64_t) <= limit; o += sizeof(uint64_t))
      {
        const uint64_t val = *(const uint64_t *)(uintptr_t)(sp + o);
        uint64_t modOffset = 0;
        const SelfDumpModuleEntry *m = SelfDumpFindModule(val, &modOffset);
        if(m)
          SelfDumpRawWrite(h, "  rsp+0x%05zx = %016llx -> %ls + 0x%llx\r\n", o,
                           (unsigned long long)val, m->name, (unsigned long long)modOffset);
      }

      at = limit;
    }
  }

  SelfDumpRawWrite(h, "\r\n=== end ===\r\n");
  CloseHandle(h);

  SelfDumpNote("%s: raw dump written - %s", tag, path.c_str());
}

static void SelfDumpWrite(const char *tag, EXCEPTION_POINTERS *ex)
{
  if(InterlockedCompareExchange(&g_SelfDumpInProgress, 1, 0) != 0)
    return;

  // The raw dump cannot fail the way the minidump writer did, so always produce it first.
  SelfDumpWriteRaw(tag, ex);

  HMODULE mod = LoadLibraryA("dbgcore.dll");
  if(!mod)
    mod = LoadLibraryA("dbghelp.dll");

  if(!mod)
  {
    SelfDumpNote("%s: minidump skipped - neither dbgcore.dll nor dbghelp.dll loaded", tag);
    return;
  }

  pfnMiniDumpWriteDump writeDump = (pfnMiniDumpWriteDump)GetProcAddress(mod, "MiniDumpWriteDump");
  if(!writeDump)
  {
    SelfDumpNote("%s: minidump skipped - no MiniDumpWriteDump export", tag);
    return;
  }

  rdcstr path = SelfDumpBasePath() + "." + tag + ".dmp";
  rdcwstr wpath = StringFormat::UTF82Wide(path);

  HANDLE h =
      CreateFileW(wpath.c_str(), GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
  if(h == INVALID_HANDLE_VALUE)
  {
    SelfDumpNote("%s: minidump failed - CreateFileW error %lu", tag, GetLastError());
    return;
  }

  // Minimal flags: the richer ones pull in extra memory reads that trip over the same corrupted
  // state that broke the unwinder.
  SelfDumpExceptionInfo info = {GetCurrentThreadId(), ex, FALSE};
  BOOL ok = writeDump(GetCurrentProcess(), GetCurrentProcessId(), h, 0x00001000 /*ThreadInfo*/,
                      ex ? &info : NULL, NULL, NULL);
  DWORD err = ok ? 0 : GetLastError();
  CloseHandle(h);

  if(ok)
    SelfDumpNote("%s: minidump written - %s", tag, path.c_str());
  else
    SelfDumpNote("%s: MiniDumpWriteDump failed - error %lu", tag, err);
}

static void *g_NullWriteScratch = NULL;
static bool g_RedirectNullWrites = false;
static volatile LONG g_NullWriteRedirects = 0;

// The fatal access violation is a write to NULL inside ntdll's unwind code, on an anti-cheat
// worker thread. If that fault is what kills the target, making the write succeed should keep it
// alive: point every zero-valued general purpose register at a writable scratch page and let the
// faulting instruction retry. Only used as an experiment, behind RDC_REDIRECT_NULL_WRITE=1.
static bool SelfDumpTryRedirectNullWrite(EXCEPTION_POINTERS *ex)
{
  if(!g_RedirectNullWrites || !ex || !ex->ExceptionRecord || !ex->ContextRecord)
    return false;

  const EXCEPTION_RECORD *er = ex->ExceptionRecord;
  if(er->NumberParameters < 2 || er->ExceptionInformation[1] != 0)
    return false;

  // The sequence seen on the target is a deliberate null dereference: first a write at NULL,
  // then, 0x44 bytes later, a read at NULL. Handle both; executing NULL is not redirected.
  const ULONG_PTR accessType = er->ExceptionInformation[0];
  if(accessType != 0 && accessType != 1)
    return false;

  if(!SelfDumpIsInNtdll(er->ExceptionAddress))
    return false;

  if(g_NullWriteScratch == NULL)
    g_NullWriteScratch = VirtualAlloc(NULL, 4096, MEM_COMMIT | MEM_RESERVE, PAGE_READWRITE);

  if(g_NullWriteScratch == NULL)
    return false;

  if(InterlockedIncrement(&g_NullWriteRedirects) > 200)
    return false;

  CONTEXT *c = ex->ContextRecord;
  const DWORD64 scratch = (DWORD64)(uintptr_t)g_NullWriteScratch;
  int redirected = 0;

  // Deliberately not Rsp/Rbp: the stack pointers must stay intact.
  if(c->Rax == 0) { c->Rax = scratch; redirected++; }
  if(c->Rbx == 0) { c->Rbx = scratch; redirected++; }
  if(c->Rcx == 0) { c->Rcx = scratch; redirected++; }
  if(c->Rdx == 0) { c->Rdx = scratch; redirected++; }
  if(c->Rsi == 0) { c->Rsi = scratch; redirected++; }
  if(c->Rdi == 0) { c->Rdi = scratch; redirected++; }
  if(c->R8 == 0) { c->R8 = scratch; redirected++; }
  if(c->R9 == 0) { c->R9 = scratch; redirected++; }
  if(c->R10 == 0) { c->R10 = scratch; redirected++; }
  if(c->R11 == 0) { c->R11 = scratch; redirected++; }

  SelfDumpNote("redirected null %s #%ld at rip=%p: %d zero registers -> scratch %p",
               accessType == 0 ? "read" : "write", g_NullWriteRedirects, er->ExceptionAddress,
               redirected, g_NullWriteScratch);

  return redirected > 0;
}

static LONG WINAPI SelfDumpFirstChance(EXCEPTION_POINTERS *ex)
{
  if(ex && ex->ExceptionRecord && ex->ExceptionRecord->ExceptionCode == 0xC0000005)
  {
    const EXCEPTION_RECORD *er = ex->ExceptionRecord;
    const void *addr = er->ExceptionAddress;
    const bool inNtdll = SelfDumpIsInNtdll(addr);

    const char *kind = "read";
    if(er->NumberParameters >= 1)
    {
      if(er->ExceptionInformation[0] == 1)
        kind = "write";
      else if(er->ExceptionInformation[0] == 8)
        kind = "execute";
    }

    char where[96] = {0};
    SelfDumpDescribeAddress((uint64_t)(uintptr_t)addr, where, sizeof(where));

    SelfDumpNote("first-chance AV: pid=%lu thread=%lu addr=%p (%s) in-ntdll=%d %s-at=0x%016llx",
                 GetCurrentProcessId(), GetCurrentThreadId(), addr, where, (int)inNtdll, kind,
                 er->NumberParameters >= 2 ? (unsigned long long)er->ExceptionInformation[1] : 0);

    if(SelfDumpTryRedirectNullWrite(ex))
      return EXCEPTION_CONTINUE_EXECUTION;

    // The known failure signature faults inside ntdll's unwind code. Dump here as well, in case
    // the unhandled filter is replaced before this exception reaches it.
    if(inNtdll)
      SelfDumpWrite("firstchance", ex);
  }

  return EXCEPTION_CONTINUE_SEARCH;
}

static LONG WINAPI SelfDumpUnhandled(EXCEPTION_POINTERS *ex)
{
  const DWORD code = (ex && ex->ExceptionRecord) ? ex->ExceptionRecord->ExceptionCode : 0;
  const void *addr = (ex && ex->ExceptionRecord) ? ex->ExceptionRecord->ExceptionAddress : NULL;

  SelfDumpNote("unhandled exception: pid=%lu code=0x%08lx thread=%lu addr=%p",
               GetCurrentProcessId(), code, GetCurrentThreadId(), addr);
  SelfDumpWrite("unhandled", ex);

  return EXCEPTION_CONTINUE_SEARCH;
}

static void InstallSelfDumpHandlers()
{
  char env[16] = {0};
  if(GetEnvironmentVariableA("RDC_REDIRECT_NULL_WRITE", env, sizeof(env)) > 0 && env[0] == '1')
    g_RedirectNullWrites = true;

  AddVectoredExceptionHandler(1, &SelfDumpFirstChance);
  SetUnhandledExceptionFilter(&SelfDumpUnhandled);

  SelfDumpNote("self-dump handlers installed: pid=%lu redirect-null-write=%d",
               GetCurrentProcessId(), (int)g_RedirectNullWrites);
}

// ---------------------------------------------------------------------------
// Automatic capture triggering.
//
// The target only survives ~20s after the graphics layer is taken over, which is far too short
// to rely on a human pressing F12. Two independent triggers are supported, both off by default:
//
//   RDC_AUTO_CAPTURE_FRAME     comma-separated frame numbers   -> QueueCapture(N)
//   RDC_AUTO_CAPTURE_DELAY_MS  comma-separated millisecond delays -> TriggerCapture(1)
//
// QueueCapture() is keyed on the wrapped device's own frame counter - the first Present of a
// wrapped device is frame 1 - so it fires once that many frames have really been presented,
// however long loading takes. The delay trigger is a wall-clock fallback for the case where the
// frame counter never reaches the requested value before the process is killed. Either way the
// resulting .rdc lands through the normal capture path, so it can be replayed with qrendertest.
// ---------------------------------------------------------------------------

static void ParseUintList(const char *env, rdcarray<uint32_t> &out)
{
  const char *p = env;
  while(p && *p)
  {
    while(*p == ' ' || *p == '\t' || *p == ',' || *p == ';')
      p++;

    if(!*p)
      break;

    uint32_t v = 0;
    bool anyDigit = false;
    while(*p >= '0' && *p <= '9')
    {
      v = v * 10u + (uint32_t)(*p - '0');
      anyDigit = true;
      p++;
    }

    if(anyDigit)
      out.push_back(v);
    else
      p++;    // not a separator and not a digit - skip it rather than spin
  }
}

struct AutoCaptureDelays
{
  rdcarray<uint32_t> delays;
};

static DWORD WINAPI AutoCaptureDelayThread(LPVOID param)
{
  AutoCaptureDelays *d = (AutoCaptureDelays *)param;

  uint32_t elapsed = 0;
  for(size_t i = 0; i < d->delays.size(); i++)
  {
    const uint32_t wait = d->delays[i] > elapsed ? (d->delays[i] - elapsed) : 0;
    if(wait)
      Sleep(wait);
    elapsed += wait;

    RDCLOG("Auto capture: TriggerCapture(1) at %u ms after injection", d->delays[i]);
    RenderDoc::Inst().TriggerCapture(1);
  }

  delete d;
  return 0;
}

static void ScheduleAutoCapture()
{
  char env[256] = {0};

  if(GetEnvironmentVariableA("RDC_AUTO_CAPTURE_FRAME", env, sizeof(env)) > 0)
  {
    rdcarray<uint32_t> frames;
    ParseUintList(env, frames);

    for(size_t i = 0; i < frames.size(); i++)
    {
      RenderDoc::Inst().QueueCapture(frames[i]);
      RDCLOG("Auto capture: QueueCapture(%u) armed - fires when the wrapped device presents that "
             "frame",
             frames[i]);
    }

    if(frames.empty())
      RDCLOG("Auto capture: RDC_AUTO_CAPTURE_FRAME set but no frame number could be parsed");
  }

  memset(env, 0, sizeof(env));
  if(GetEnvironmentVariableA("RDC_AUTO_CAPTURE_DELAY_MS", env, sizeof(env)) > 0)
  {
    AutoCaptureDelays *d = new AutoCaptureDelays();
    ParseUintList(env, d->delays);

    // Sort ascending so each sleep is measured from the previous trigger and the triggers stay
    // in wall-clock order. Insertion sort: the list is a handful of entries.
    for(size_t i = 1; i < d->delays.size(); i++)
    {
      const uint32_t key = d->delays[i];
      size_t j = i;
      while(j > 0 && d->delays[j - 1] > key)
      {
        d->delays[j] = d->delays[j - 1];
        j--;
      }
      d->delays[j] = key;
    }

    if(d->delays.empty())
    {
      RDCLOG("Auto capture: RDC_AUTO_CAPTURE_DELAY_MS set but no delay could be parsed");
      delete d;
    }
    else
    {
      // Read these before handing the struct to the thread: it owns (and frees) them from here on.
      const uint32_t delayCount = (uint32_t)d->delays.size();
      const uint32_t lastDelay = d->delays.back();

      HANDLE h = CreateThread(NULL, 0, &AutoCaptureDelayThread, d, 0, NULL);
      if(h == NULL)
      {
        RDCLOG("Auto capture: delay thread could not be created - error %lu", GetLastError());
        delete d;
      }
      else
      {
        CloseHandle(h);
        RDCLOG("Auto capture: %u wall-clock trigger(s) armed, last at %u ms", delayCount,
               lastDelay);
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Import-table patch scope.
//
// RenderDoc patches the import table of *every* loaded module that imports a hooked function. Its
// built-in ignore list only covers Windows components and graphics drivers, so a module like
// mhypbase.dll gets its own IAT rewritten - and that module imports CreateDXGIFactory, which is
// exactly what the DXGI hooks register. In other words, with DXGI hooking on we point the
// anti-cheat's own import entry at our DLL.
//
// RDC_SKIP_IAT_MODULE=<name>[,<name>...] leaves those modules' import tables alone. Note this can
// only be applied during hook registration: LibraryHooks::IgnoreLibrary() writes into state that
// BeginHookRegistration() allocates, so it cannot be called from add_hooks() directly.
// ---------------------------------------------------------------------------

class IatScopeHook : public LibraryHook
{
public:
  void RegisterHooks() override
  {
    char env[512] = {0};
    if(GetEnvironmentVariableA("RDC_SKIP_IAT_MODULE", env, sizeof(env)) <= 0)
      return;

    const char *p = env;
    while(*p)
    {
      while(*p == ' ' || *p == '\t' || *p == ',' || *p == ';')
        p++;

      if(!*p)
        break;

      const char *start = p;
      while(*p && *p != ' ' && *p != '\t' && *p != ',' && *p != ';')
        p++;

      rdcstr module(start, size_t(p - start));
      LibraryHooks::IgnoreLibrary(module.c_str());
      RDCLOG("Capture DLL: import table of '%s' left untouched (RDC_SKIP_IAT_MODULE)",
             module.c_str());
    }
  }
};

static IatScopeHook iatScopeHook;

static BOOL add_hooks()
{
  wchar_t curFile[512];
  GetModuleFileNameW(NULL, curFile, 512);

  rdcstr f = get_basename(strlower(StringFormat::Wide2UTF8(curFile)));

  // bail immediately if we're in a system process. We don't want to hook, log, anything -
  // this instance is being used for a shell extension.
  if(f == "dllhost.exe" || f == "explorer.exe")
  {
#if ENABLED(RDOC_RELEASE)
    OutputDebugStringA(
        "Detecting shell process! Disabling hooking in dllhost.exe or explorer.exe\n");
#endif
    return TRUE;
  }

  // search for an exported symbol with this name, typically renderdoc__replay__marker
  if(LibraryHooks::Detect(STRINGIZE(RDOC_BASE_NAME) "__replay__marker"))
  {
    RDCDEBUG("Not creating hooks - in replay app");

    RenderDoc::Inst().SetReplayApp(true);

    RenderDoc::Inst().Initialise();

    LibraryHooks::ReplayInitialise();

    return true;
  }

  // The disk logger is not initialised yet. Keep the early marker minimal in DllMain.
  OutputDebugStringA("RenderTest capture: Initialise begin\n");
  RenderDoc::Inst().Initialise();

  RDCLOG("Capture DLL: Initialise complete, PID %lu, loading into %ls", GetCurrentProcessId(),
         curFile);

  // Install as early as possible: cross-process dumpers are refused by the target's protection,
  // so an in-process handler is the only way to get a crash dump out of this process.
  InstallSelfDumpHandlers();

  char noHooksEnv[16] = {0};
  const bool skipHooks =
      GetEnvironmentVariableA("RDC_NO_HOOKS", noHooksEnv, sizeof(noHooksEnv)) > 0 &&
      noHooksEnv[0] == '1';

  // Injection-only control run: the DLL is loaded (and the self-dump handlers are installed) but
  // no API hook is placed. Used to tell "the module's presence is detected" apart from
  // "our hooks are detected".
  if(skipHooks)
  {
    RDCLOG("Capture DLL: RegisterHooks skipped (RDC_NO_HOOKS=1) - injection-only control run");
  }
  else
  {
    RDCLOG("Capture DLL: RegisterHooks begin");
    LibraryHooks::RegisterHooks();
    RDCLOG("Capture DLL: RegisterHooks complete");

    // With no hooks installed there is nothing to capture, so this is skipped along with them.
    ScheduleAutoCapture();
  }

  return TRUE;
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
  if(ul_reason_for_call == DLL_PROCESS_ATTACH)
  {
    BOOL ret = add_hooks();
    SetLastError(0);
    return ret;
  }

  return TRUE;
}
