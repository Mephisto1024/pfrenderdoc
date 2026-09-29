// dxil-decompiler - DXIL to HLSL front end built on RenoDX's DXC decompiler header.
//
// Modes:
//
//   dxil-decompiler.exe <dxc -dumpbin text> [more disassemblies...]
//       Decompile each DXIL disassembly to "<input>.hlsl". Used by tests/test_heap_types.py.
//
//   dxil-decompiler.exe --stdout [--dxc <path>] <input>
//       RenderDoc shader-processing-tool mode. This is what the UI.config entry points at.
//       <input> may be a raw DXIL container - exactly what RenderDoc writes to
//       %TEMP%\\shader_input, with no file extension - or an already-disassembled text file.
//       The HLSL is written to stdout and NOTHING else is: RenderDoc captures our stdout as the
//       shader result, while our stderr is written to a separate file and only shown in the log.
//
//   dxil-decompiler.exe --infer-type <word0> <word1> <resource|sampler>
//       Print the HLSL type for a descriptor-heap annotation. Used by tests/test_heap_types.py.
//
// dxc is only needed in --stdout mode, and only when the input is a raw container. It is located
// from --dxc, then the DXC environment variable, then PATH, then the newest Windows SDK.

#include <algorithm>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <iterator>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

// The vendored decompiler header is included before windows.h on purpose: windows.h pulls in
// rpcndr.h, whose legacy "small"/"near"/"far" macros can collide with identifiers in the header.
#include "shader_decompiler_dxc.hpp"

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>

namespace {

namespace fs = std::filesystem;

using renodx::utils::shader::decompiler::dxc::Decompiler;

constexpr std::string_view kDisassemblyMarker = "target triple = \"dxil-ms-dx\"";
constexpr std::string_view kContainerMarker = "DXBC";

std::string ReadBinary(const fs::path &path)
{
  std::ifstream input(path, std::ios::binary);
  if(!input)
    throw std::runtime_error("Cannot open input");
  return std::string{std::istreambuf_iterator<char>{input}, std::istreambuf_iterator<char>{}};
}

void WriteBinary(const fs::path &path, std::string_view data)
{
  std::ofstream output(path, std::ios::binary);
  if(!output)
    throw std::runtime_error("Cannot open output");
  output.write(data.data(), static_cast<std::streamsize>(data.size()));
  if(!output)
    throw std::runtime_error("Cannot write output");
}

bool LooksLikeDisassembly(std::string_view text)
{
  return text.find(kDisassemblyMarker) != std::string_view::npos;
}

bool LooksLikeContainer(std::string_view data)
{
  return data.size() >= kContainerMarker.size() && data.compare(0, kContainerMarker.size(),
                                                               kContainerMarker) == 0;
}

std::string WideToUtf8(const std::wstring &text)
{
  if(text.empty())
    return {};

  const int size = WideCharToMultiByte(CP_UTF8, 0, text.data(), static_cast<int>(text.size()),
                                       nullptr, 0, nullptr, nullptr);
  if(size <= 0)
    return {};

  std::string result(static_cast<size_t>(size), '\0');
  WideCharToMultiByte(CP_UTF8, 0, text.data(), static_cast<int>(text.size()), result.data(), size,
                      nullptr, nullptr);
  return result;
}

// Prefer the path the user gave us, then DXC, then PATH, then the newest Windows SDK. Returns an
// empty path when nothing was found - the caller turns that into a message naming every option.
fs::path FindDxc(const fs::path &explicit_path)
{
  std::error_code ec;

  if(!explicit_path.empty())
  {
    if(fs::is_regular_file(explicit_path, ec))
      return explicit_path;
    throw std::runtime_error("--dxc path is not a file: " + WideToUtf8(explicit_path.wstring()));
  }

  if(const wchar_t *from_env = _wgetenv(L"DXC"); from_env != nullptr && *from_env != L'\0')
  {
    const fs::path candidate(from_env);
    if(fs::is_regular_file(candidate, ec))
      return candidate;
  }

  {
    wchar_t resolved[MAX_PATH] = {};
    if(SearchPathW(nullptr, L"dxc.exe", nullptr, MAX_PATH, resolved, nullptr) != 0)
      return fs::path(resolved);
  }

  // Windows SDK layout: <ProgramFiles(x86)>\Windows Kits\10\bin\<version>\x64\dxc.exe.
  // Versions sort usefully as plain strings ("10.0.22621.0" < "10.0.26100.0"), so take the last.
  if(const wchar_t *program_files = _wgetenv(L"ProgramFiles(x86)");
     program_files != nullptr && *program_files != L'\0')
  {
    const fs::path bin_dir = fs::path(program_files) / L"Windows Kits" / L"10" / L"bin";

    std::vector<fs::path> candidates;
    for(const auto &entry : fs::directory_iterator(bin_dir, ec))
    {
      if(!entry.is_directory(ec))
        continue;

      const fs::path candidate = entry.path() / L"x64" / L"dxc.exe";
      if(fs::is_regular_file(candidate, ec))
        candidates.push_back(candidate);
    }

    if(!candidates.empty())
    {
      std::sort(candidates.begin(), candidates.end());
      return candidates.back();
    }
  }

  return {};
}

// Run "dxc -dumpbin <input>" and return its stdout as the disassembly text. dxc writes both its
// disassembly and any diagnostics to the same temporary file, so a non-zero exit means the text we
// captured is an error report - hand it back verbatim rather than pretending it is disassembly.
std::string RunDxcDumpbin(const fs::path &dxc, const fs::path &input)
{
  wchar_t temp_dir[MAX_PATH] = {};
  if(GetTempPathW(MAX_PATH, temp_dir) == 0)
    throw std::runtime_error("Cannot locate the temporary directory");

  wchar_t temp_name[MAX_PATH] = {};
  if(GetTempFileNameW(temp_dir, L"dxd", 0, temp_name) == 0)
    throw std::runtime_error("Cannot create a temporary file");

  const fs::path temp_path(temp_name);

  SECURITY_ATTRIBUTES security = {};
  security.nLength = sizeof(security);
  security.bInheritHandle = TRUE;

  HANDLE output = CreateFileW(temp_name, GENERIC_WRITE, FILE_SHARE_READ, &security, CREATE_ALWAYS,
                              FILE_ATTRIBUTE_TEMPORARY, nullptr);
  if(output == INVALID_HANDLE_VALUE)
  {
    DeleteFileW(temp_name);
    throw std::runtime_error("Cannot open a temporary file for dxc output");
  }

  HANDLE null_input = CreateFileW(L"NUL", GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE,
                                  &security, OPEN_EXISTING, 0, nullptr);

  std::error_code ec;
  fs::path absolute_input = fs::absolute(input, ec);
  if(ec)
    absolute_input = input;

  std::wstring command = L"\"" + dxc.wstring() + L"\" -dumpbin \"" + absolute_input.wstring() + L"\"";

  STARTUPINFOW startup = {};
  startup.cb = sizeof(startup);
  startup.dwFlags = STARTF_USESTDHANDLES;
  startup.hStdOutput = output;
  startup.hStdError = output;
  startup.hStdInput = (null_input == INVALID_HANDLE_VALUE) ? nullptr : null_input;

  PROCESS_INFORMATION process = {};
  const BOOL started = CreateProcessW(nullptr, command.data(), nullptr, nullptr, TRUE,
                                      CREATE_NO_WINDOW, nullptr, nullptr, &startup, &process);

  DWORD exit_code = 1;
  if(started != 0)
  {
    WaitForSingleObject(process.hProcess, 120000);
    GetExitCodeProcess(process.hProcess, &exit_code);
    CloseHandle(process.hThread);
    CloseHandle(process.hProcess);
  }

  CloseHandle(output);
  if(null_input != INVALID_HANDLE_VALUE)
    CloseHandle(null_input);

  std::string captured;
  try
  {
    captured = ReadBinary(temp_path);
  }
  catch(const std::exception &)
  {
    // fall through with whatever we have; the errors below cover the interesting cases
  }

  DeleteFileW(temp_name);

  if(started == 0)
    throw std::runtime_error("Failed to start dxc: " + WideToUtf8(dxc.wstring()));

  if(exit_code != 0)
    throw std::runtime_error("dxc -dumpbin failed with exit code " + std::to_string(exit_code) +
                             ":\n" + captured.substr(0, 2000));

  return captured;
}

std::string DecompileDisassembly(std::string_view disassembly,
                                const Decompiler::DecompileOptions &options)
{
  Decompiler decompiler;
  return decompiler.Decompile(disassembly, options);
}

// Structuring modes, tried in order. `use_do_while` is not a free switch - it also emits do/while
// loops instead of plain ones, so turning it on for everything would change the output of shaders
// that already decompile. Trying it only after the default throws keeps existing results identical
// while still handling shaders whose control flow needs it.
struct DecompileAttempt
{
  Decompiler::DecompileOptions options;
  const char *name;
};

std::string DecompileWithFallback(std::string_view disassembly, std::string &used_mode)
{
  const DecompileAttempt attempts[] = {
      {{.flatten = false, .use_do_while = false}, "default"},
      {{.flatten = false, .use_do_while = true}, "do-while"},
      {{.flatten = true, .use_do_while = true}, "flatten+do-while"},
  };

  std::string last_error;
  for(const DecompileAttempt &attempt : attempts)
  {
    try
    {
      std::string hlsl = DecompileDisassembly(disassembly, attempt.options);
      used_mode = attempt.name;
      return hlsl;
    }
    catch(const std::exception &e)
    {
      last_error = e.what();
      std::cerr << "dxil-decompiler: " << attempt.name << " structuring failed: " << last_error
                << "\n";
    }
  }

  throw std::runtime_error("No structuring mode could decompile this shader; last error: " +
                           last_error);
}

// RenderDoc captures our stdout as the shader source, so the HLSL must be the only thing on it.
int RunForRenderDoc(const fs::path &input, const fs::path &dxc_override,
                    const Decompiler::DecompileOptions &options, bool force_options)
{
  const std::string data = ReadBinary(input);

  std::string disassembly;
  if(LooksLikeDisassembly(data))
  {
    // Somebody already disassembled it, or the tool is being driven by hand.
    std::cerr << "dxil-decompiler: input is already DXIL disassembly text\n";
    disassembly = data;
  }
  else if(LooksLikeContainer(data))
  {
    const fs::path dxc = FindDxc(dxc_override);
    if(dxc.empty())
      throw std::runtime_error(
          "Could not find dxc.exe, which is required to disassemble a DXIL container.\n"
          "Install the Windows SDK, put dxc on PATH, set the DXC environment variable, or pass "
          "--dxc <path>.");

    std::cerr << "dxil-decompiler: disassembling with " << WideToUtf8(dxc.wstring()) << "\n";
    disassembly = RunDxcDumpbin(dxc, input);
  }
  else
  {
    throw std::runtime_error(
        "Input is neither a DXIL container nor dxc -dumpbin disassembly text");
  }

  if(!LooksLikeDisassembly(disassembly))
    throw std::runtime_error("dxc -dumpbin did not produce DXIL disassembly");

  std::string hlsl;
  {
    // The vendored decompiler header is a debug-friendly research tool and may print diagnostics to
    // std::cout. Park std::cout on stderr for the duration of the call so stray prints end up in the
    // log with everything else, and only ever write the HLSL itself to the real stdout.
    std::streambuf *real_stdout = std::cout.rdbuf(std::cerr.rdbuf());
    try
    {
      if(force_options)
      {
        hlsl = DecompileDisassembly(disassembly, options);
      }
      else
      {
        std::string used_mode;
        hlsl = DecompileWithFallback(disassembly, used_mode);
        std::cerr << "dxil-decompiler: decompiled with " << used_mode << " structuring\n";
      }
    }
    catch(...)
    {
      std::cout.rdbuf(real_stdout);
      throw;
    }
    std::cout.rdbuf(real_stdout);
  }

  if(hlsl.empty())
    throw std::runtime_error("The decompiler produced no HLSL");

  std::cout.write(hlsl.data(), static_cast<std::streamsize>(hlsl.size()));
  if(hlsl.back() != '\n')
    std::cout.put('\n');
  std::cout.flush();

  if(!std::cout)
    throw std::runtime_error("Failed to write HLSL to stdout");

  return 0;
}

int RunInferType(wchar_t **argv)
{
  const std::string properties =
      "{ i32 " + WideToUtf8(argv[2]) + ", i32 " + WideToUtf8(argv[3]) + " }";
  const bool sampler_heap = std::wstring(argv[4]) == L"sampler";

  std::cout << Decompiler::InferHeapHlslType(properties, sampler_heap) << "\n";
  return 0;
}

// Decompile each named disassembly next to itself, as "<input>.hlsl". Each file is reported
// independently so one bad input does not hide the others, and a failure never leaves a partial
// .hlsl behind for a caller to mistake for a result.
int RunBatch(int argc, wchar_t **argv)
{
  bool failed = false;

  for(int i = 1; i < argc; ++i)
  {
    try
    {
      const std::string disassembly = ReadBinary(argv[i]);
      if(!LooksLikeDisassembly(disassembly))
        throw std::runtime_error("Expected DXIL disassembly text from dxc -dumpbin");

      const std::string hlsl = DecompileDisassembly(disassembly, Decompiler::DecompileOptions{});
      const fs::path output_path = fs::path(argv[i]).wstring() + L".hlsl";
      WriteBinary(output_path, hlsl);

      std::cout << WideToUtf8(output_path.wstring()) << " (" << hlsl.size() << " bytes)\n";
    }
    catch(const std::exception &e)
    {
      failed = true;
      std::cerr << WideToUtf8(argv[i]) << ": " << e.what() << "\n";
    }
  }

  return failed ? 1 : 0;
}

const char *kUsage =
    "Usage: dxil-decompiler.exe <dxc -dumpbin text> [more disassemblies...]\n"
    "       dxil-decompiler.exe --stdout [--dxc <path>] [--flatten] [--do-while] <dxil container | disassembly>\n"
    "       dxil-decompiler.exe --infer-type <word0> <word1> <resource|sampler>\n";

}  // namespace

int wmain(int argc, wchar_t **argv)
{
  try
  {
    if(argc == 5 && std::wstring(argv[1]) == L"--infer-type")
      return RunInferType(argv);

    if(argc >= 2 && std::wstring(argv[1]) == L"--stdout")
    {
      fs::path dxc_override;
      fs::path input;
      Decompiler::DecompileOptions options;
      bool force_options = false;

      for(int i = 2; i < argc; ++i)
      {
        const std::wstring arg = argv[i];
        if(arg == L"--dxc")
        {
          if(i + 1 >= argc)
            throw std::runtime_error("--dxc requires a path");
          dxc_override = argv[++i];
        }
        else if(arg == L"--flatten")
        {
          options.flatten = true;
          force_options = true;
        }
        else if(arg == L"--do-while")
        {
          // Some control flow can only be expressed with a break out of a do-while loop. Without
          // this the decompiler refuses with "Unexpected goto" rather than emit wrong code. Asking
          // for it explicitly pins the structuring mode; the default already retries with it.
          options.use_do_while = true;
          force_options = true;
        }
        else if(input.empty())
        {
          input = arg;
        }
        else
        {
          throw std::runtime_error("Unexpected extra argument: " + WideToUtf8(arg));
        }
      }

      if(input.empty())
        throw std::runtime_error("--stdout requires an input file");

      return RunForRenderDoc(input, dxc_override, options, force_options);
    }

    if(argc < 2)
    {
      std::cerr << kUsage;
      return 2;
    }

    return RunBatch(argc, argv);
  }
  catch(const std::exception &e)
  {
    std::cerr << e.what() << "\n";
    return 1;
  }
}
