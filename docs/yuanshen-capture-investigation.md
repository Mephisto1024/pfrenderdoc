# YuanShen.exe 截帧目标与排查记录

更新日期：2026-09-28 00:45（Asia/Shanghai）

## 目标与完成标准

使用 `E:\pfrenderdoc-build\x64\Release` 中的截帧工具，成功截取以下目标程序的一帧：

```text
D:\miHoYo Launcher\games\Genshin Impact Game\YuanShen.exe
```

完成标准：目标运行至实际渲染画面，触发截帧并生成有效 `.rdc` 文件，使用 `qrendertest.exe` 打开并确认包含可分析的帧内容。仅启动进程、完成 DLL 注入或获得控制连接 ID，均不代表截帧成功。

**当前状态（2026-09-28 00:45）**：

- **目标已达成**：配置 `-SkipIatModule mhypbase.dll`（d3d11/dxgi 两组 hook 全开，只不改写该模块的导入表）下，进程不再被硬杀，存活 79–130 s，并已取到**真实游戏画面**的 `.rdc`（璃月城内，角色+HUD+NPC），`thumb` 抽帧与 `replay -l 1` 均通过。详见下文"IAT 补丁范围二分"与"工作配置已复现"。
- **硬杀成因已证实**：来自把 `mhypbase.dll` 自己的 `CreateDXGIFactory` 导入项改指向 `rendertest.dll`。跳过该模块的 IAT 改写后 AV 完全消失；与设备/交换链包装无关。
- **交换链来源已查清**：目标走 `CreateDXGIFactory*` + `IDXGIFactory::CreateSwapChain`，全树从不使用 `D3D11CreateDeviceAndSwapChain`。
- **自动截帧已打通并验证**：`RDC_AUTO_CAPTURE_FRAME`（帧号）+ `RDC_AUTO_CAPTURE_DELAY_MS`（墙钟）两路，不需要手速；`RDC_AUTO_CAPTURE_DELAY_MS=20000 45000 65000` 一轮即拿到 5 份帧，其中 3 份是游戏内画面。
- **GUI 路径同样可用，且无需改代码**：`rendertestui.exe`/`qrendertest.exe` 与 CLI 走同一套注入代码，差别只在开关传递；用 `run-rendertestui.ps1` 自提权并带上 `RDC_SKIP_IAT_MODULE=mhypbase.dll` 即可。详见下文"GUI 路径"。
- **剩余唯一瓶颈**：第二层"温和退出"（无 AV、无 WER、`exit 0`），实测在 79–130 s 之间浮动。它只决定窗口长度，不影响能否截帧。
- **崩溃取证手段齐备**：进程内 raw dump（`selfdump_*.firstchance.raw.txt`）可稳定拿到反作弊工作线程在 ntdll 写 NULL 的一手异常，用于判断某配置是否仍触发硬杀。
- **注意**：`result.txt` 里的 Application Error 段落可能捞到 10 分钟内**上一轮**的旧事件，判断某轮是否被杀应看 `selfdump_<该轮PID>.crash.txt` 与诊断日志退出码。

## 用户说明与工作范围

- 用户说明该客户端由其编写，源码已丢失。
- 用户明确要求不考虑查看客户端源码。后续基于现有二进制、依赖、运行状态及日志排查，不再以提供客户端源码为前提。
- 文件签名和版本信息是客观检查结果，不单独用于判定整个项目的归属。
- 未找到该目标的现成开发构建。不能通过一个启动参数将现有发布二进制转换为开发构建。
- 用户随后确认直接启动正常；已据此尝试“不注入截帧 DLL，仅附加调试器”的对照，结果见下文。

## 环境与工具

| 项目 | 路径或说明 |
| --- | --- |
| 源码工作区 | `E:\pfrenderdoc` |
| 构建工作区 | `E:\pfrenderdoc-build` |
| 编译配置 | x64 Release，MSVC v142 |
| 命令行工具 | `E:\pfrenderdoc-build\x64\Release\rendertestcmd.exe` |
| 截帧 DLL | `E:\pfrenderdoc-build\x64\Release\rendertest.dll` |
| 分析界面 | `E:\pfrenderdoc-build\x64\Release\qrendertest.exe` |
| 输出根目录 | `E:\pfrenderdoc-captures`，自 2026-09-28 起为独立 git 仓库（分支 `main`，`.gitignore` 排除 `*.dmp`、`*.rdc` 等大二进制） |
| 批量二分脚本 | `E:\pfrenderdoc-captures\run-bisect.ps1`，一次提权连跑多个配置并把结果汇总到 `bisect-<时间戳>.txt` |
| GUI 启动包装 | `E:\pfrenderdoc-captures\run-rendertestui.ps1`，自提权 + 设好开关 + 启动 `rendertestui.exe` |
| ProcDump | `C:\Program Files\Procdump\procdump64.exe`，运行时显示 v12.01 |
| WinDbg 包 | `C:\Program Files\WindowsApps\Microsoft.WinDbg_1.2606.22001.0_x64__8wekyb3d8bbwe` |
| CDB | 上述 WinDbg 包目录下的 `amd64\cdb.exe` |

用户曾提供 `C:\Windows\System32\wbem` 作为 WinDbg 所在位置；实际通过安装包信息找到的路径如上。WindowsApps 路径可能随更新改变，使用前重新确认。

## 已完成的诊断代码修改

修改位于源码工作区，并同步到构建工作区相同相对路径。已重新生成 `rendertest.dll` 和 `rendertestcmd.exe`。

| 源文件 | 修改内容 |
| --- | --- |
| `renderdoccmd/renderdoccmd.cpp` | 新增 `capture --diagnostic-log`，在启动调用返回后导出日志；输出实时日志路径；明确控制连接 ID 不是 PID 或退出码。 |
| `renderdoc/os/win32/win32_process.cpp` | 保留创建进程的 Windows 错误码；记录 PID、注入结果、恢复线程返回值；等待模式改为等待整个进程，随后读取并记录退出码。 |
| `renderdoc/os/win32/win32_libentry.cpp` | 增加初始化与 Hook 注册阶段标记。初始化前标记通过 `OutputDebugStringA` 输出，后续标记进入常规日志。 |
| `renderdoc/os/win32/win32_libentry.cpp`（自动截帧） | 新增 `ScheduleAutoCapture()`：由 `RDC_AUTO_CAPTURE_FRAME`（帧号列表 → `QueueCapture`）与 `RDC_AUTO_CAPTURE_DELAY_MS`（毫秒延迟列表 → `TriggerCapture`）两路自动触发截帧，在 `RegisterHooks()` 之后生效。详见下文“自动截帧已可用”。 |
| `renderdoc/driver/d3d11/d3d11_hooks.cpp` | 在 `D3D11Hook::Create_Internal` 中取消 `D3D11_CREATE_DEVICE_PREVENT_ALTERING_LAYER_SETTINGS_FROM_REGISTRY` 的早退：仍记录该标志，但不再跳过设备包装。上游在此处会直接记录 `Application requested not to be hooked.` 并放弃接管设备。详见下文“D3D11 层设置退出标志的本地覆盖”。 |

注意：`--diagnostic-log` 在启动调用返回后保存日志快照。需要同时使用 `--wait-for-exit` 才能包含正常监视到的最终进程退出码；若启动工具本身被强制终止，最终快照不保证保存。默认临时日志存在正常退出清理逻辑。

验证结果：

- 自建测试程序主线程先通过 `ExitThread(7)` 退出，工作线程稍后调用 `ExitProcess(42)`。工具正确等待整个进程并记录 `0x0000002a (42)`。
- 不存在的 EXE 路径正确报告 Windows 错误码 2，并保存日志。
- DLL 初始化与 Hook 注册标记能够保存。
- 工具本身返回码与目标进程退出码分开解释：目标退出码 42 的测试中，启动工具成功返回 0。
- `git diff --check` 通过。修改尚未提交。
- 构建工作区原有 `renderdocshim/renderdocshim.cpp` 本地修改未在本次排查中改动。

构建日志：

```text
E:\pfrenderdoc-build\build-logs\capture-diagnostics-dll-x64.log
E:\pfrenderdoc-build\build-logs\capture-diagnostics-cmd-x64.log
```

测试文件与日志：`E:\pfrenderdoc-captures\diagnostics-smoke`。

## 启动方式

目标要求管理员权限。普通权限启动曾返回 Windows 错误码 740；提权后可以创建目标进程并完成注入。

在管理员 PowerShell 中使用以下方式启动。每次排查应新建输出目录，避免覆盖证据：

```powershell
$captureRun = Join-Path 'E:\pfrenderdoc-captures' (Get-Date -Format 'yyyyMMdd-HHmmss')
New-Item -ItemType Directory -Path $captureRun | Out-Null

& 'E:\pfrenderdoc-build\x64\Release\rendertestcmd.exe' capture `
  --wait-for-exit `
  --diagnostic-log (Join-Path $captureRun 'diagnostic.log') `
  --working-dir 'D:\miHoYo Launcher\games\Genshin Impact Game' `
  --capture-file (Join-Path $captureRun 'YuanShen') `
  'D:\miHoYo Launcher\games\Genshin Impact Game\YuanShen.exe'
```

如果目标稳定运行且图形 API 被接管，可通过 F12 或目标控制接口触发截帧。目前尚未到达该状态。

部分启动脚本把原生命令 stderr 重定向到日志，Windows PowerShell 将普通状态行包装成 `NativeCommandError`。应以实际诊断日志和返回值判断结果，不把这一包装本身当作注入失败。

## 已观察到的结果

### 诊断版首次复现

目录：`E:\pfrenderdoc-captures\20260927-210208`。

- 创建 PID 27436。
- 截帧 DLL 初始化与 Hook 注册完成。
- 注入返回 Success，目标控制连接 ID 为 38920。
- 两次恢复主线程分别返回此前挂起计数 1、0。
- 后续出现 `IDXGIAdapterInternal2` 未支持接口警告。
- D3D11 路径记录 `Application requested not to be hooked.`。
- 约 5 秒后进程退出，退出码为 `0xc0000005 (3221225477)`。

对应源码 `renderdoc/driver/d3d11/d3d11_hooks.cpp` 显示，上述“不接管”日志由设备创建 Flags 中的 `D3D11_CREATE_DEVICE_PREVENT_ALTERING_LAYER_SETTINGS_FROM_REGISTRY` 标志触发。本次设备创建未进入正常包装分支。没有证据证明该标志或前述接口警告导致了退出。

### ProcDump 三次尝试

| 输出目录（均位于 `E:\pfrenderdoc-captures`） | 参数要点 | 结果 |
| --- | --- | --- |
| `dump-20260927-211028` | `-ma -e -w YuanShen.exe` | 成功附加；未捕获未处理访问冲突；进程退出；未生成 dump。 |
| `termination-20260927-211102` | `-ma -t -w YuanShen.exe` | 终止监视启用；进程退出；未生成 dump。 |
| `exception-20260927-211146` | `-ma -e 1 -f C0000005 -t -w YuanShen.exe` | 首次异常过滤及终止监视启用；仍未捕获访问冲突或生成 dump。 |

日志中出现 `80000003.BREAKPOINT`，最终均报告 `Dump count not reached`。不能将这些断点等同于目标故障。ProcDump 的 stdout 重定向日志需要按 UTF-16LE（PowerShell `-Encoding Unicode`）读取。第三次尝试另存了 UTF-8 的 `procdump-readable.log`。

### CDB 实时调试

首次目录：`E:\pfrenderdoc-captures\debug-20260927-212058`。

采用 `--opt-delay-for-debugger 60` 在注入前等待调试器，并设置访问冲突、`ntdll!RtlExitUserProcess`、`ntdll!NtTerminateProcess` 的记录命令。首次会话停在额外的初始断点，随后为调整自动脚本而结束；不要将该次结束作为目标自然退出证据。

第二次目录：`E:\pfrenderdoc-captures\debug-20260927-212149`。

- 调整脚本后，调试器越过断点事件并观察到截帧 DLL 初始化完成。
- 目标 PID 为 3348。加载模块记录中包含 `MHYPBase.dll`。
- 随后反复出现 `GetContextState failed, 0x80070005`。
- `.lastevent` 显示最后事件为线程创建，而不是已确认的访问冲突事件。
- `kv 30` 无法取得初始线程上下文，因而未输出有效故障调用栈。
- `.dump /ma` 返回 `GenGetProcessInfo.Start ... failed, 0x80070005` 及 `Dump creation failed, Win32 error 0n5: Access is denied.`。
- 目标最终仍以 `0xc0000005` 退出。未得到有效 dump。
- 调试器已使用管理员权限；本次创建的残留 CDB 进程已清理。

关键证据文件：

```text
E:\pfrenderdoc-captures\debug-20260927-212149\debugger.log
E:\pfrenderdoc-captures\debug-20260927-212149\inspect.log
E:\pfrenderdoc-captures\debug-20260927-212149\diagnostic.log
E:\pfrenderdoc-captures\debug-20260927-212149\commands.txt
E:\pfrenderdoc-captures\debug-20260927-212149\debug-launch.ps1
```

### 仅附加调试器、不注入截帧 DLL 的对照

时间：2026-09-27 22:25，输出目录：`E:\pfrenderdoc-captures\debugger-only-20260927-222521`。

- 用户先确认直接启动正常；该基线是用户报告，不是此前注入实验的推断。
- 管理员 PowerShell 直接启动目标，使用相同工作目录；未调用 `rendertestcmd.exe`，未通过本次流程注入截帧 DLL。
- 目标 PID 33504，启动后约 2 秒尝试使用管理员 CDB 附加。
- CDB 直接报告 `Cannot debug pid 33504, NTSTATUS 0xC0000022`，即 Access Denied，随后退出。调试会话未成功建立，预设的异常和退出断点未执行。
- 45 秒观察窗口结束后目标仍存在，后续状态检查为 `Responding=True`，窗口标题为“原神”。没有观察到本次目标退出；这不等于已经验证全部画面或长时间稳定性。
- 在目标运行期间检查到 `HoYoProtect` 驱动为 Running。只能确认同时存在，不能单独证明该驱动就是访问拒绝的原因。
- 保留目标进程运行，没有主动关闭客户端。

结论：调试附加访问被拒绝可以在未使用截帧注入的情况下出现。因此，不能把此前所有调试失败归因于截帧 DLL；但本次未建立调试会话，也不能得出“目标在调试器控制下运行正常”的结论。

证据：该目录中的 `debugger.log`、`status.txt`、`driver-state.txt`、`target-state.txt`、`launch-debugger-only.ps1`。

### D3D11 层设置退出标志的本地覆盖

时间：2026-09-27 23:15。源码工作区改动，已同步到构建工作区并重编。

- **位置**：`renderdoc/driver/d3d11/d3d11_hooks.cpp`，`D3D11Hook::Create_Internal` 内，`real(...)` 返回之后。
- **改动前**：检测到 `D3D11_CREATE_DEVICE_PREVENT_ALTERING_LAYER_SETTINGS_FROM_REGISTRY` 即只记录 `Application requested not to be hooked.`，不进入 `new WrappedID3D11Device(...)` 分支。该日志此前是注入后唯一可见的 D3D11 侧结果。
- **改动后**：仍检测并记录该标志，但不再早退；`SUCCEEDED(ret) && ppDevice` 时照常包装设备并包装 `IDXGISwapChain`。日志文本改为 `Application requested not to be hooked via D3D11_CREATE_DEVICE_PREVENT_ALTERING_LAYER_SETTINGS_FROM_REGISTRY - ignoring and hooking anyway.`，便于与旧记录区分。
- **覆盖面**：直接 `D3D11CreateDevice*` 与 NVAPI/AMD 的 hook 都经 `CreateD3D11_Internal` 进入同一个 `Create_Internal`，因此一处改动覆盖三条入口。全仓库检索该标志只命中 `d3d11.h` 的定义与这一处判断。
- **已知副作用**：`Create_Internal` 仍按捕获选项强制/清除 `D3D11_CREATE_DEVICE_DEBUG` 位（`apiValidation` 默认关闭时是清除）。严格说这仍属于该标志想阻止的“修改 layer 设置”；本次未一并处理，以便把实验变量控制在一个。
- **构建**：构建工作区 `E:\pfrenderdoc-build`，x64 Release，PlatformToolset=v142（cl 14.29.30133）。直接编 `.vcxproj` 时必须补 `/p:SolutionDir=E:\pfrenderdoc-build\`，否则 `$(SolutionDir)\util\WindowsSDKTarget.props` 解析失败并报 MSB4019。
- **构建日志**：`E:\pfrenderdoc-build\build-logs\optout-override-dll-x64.log`、`optout-override-cmd-x64.log`，均为 Build succeeded、0 Warning、0 Error。
- **产物**：`E:\pfrenderdoc-build\x64\Release\rendertest.dll`（24567296 字节）、`rendertestcmd.exe`，2026-09-27 23:15。
- **产物核对**：`rendertest.dll` 中含字符串 `not to be hooked via` 与 `hooking anyway.`，不含旧的 `not to be hooked.` 字面量。
- **可观测信号**：Release 构建下 `RDCDEBUG` 通常不输出，所以 `created wrapped device.` 可能看不到；应以新的 `RDCLOG` 行是否出现、以及此后的行为与退出码为准。
- **尚未验证**：该覆盖是否让目标运行到可截图状态。下一次运行需在管理员 PowerShell 中、使用新的输出目录，核对新日志行与退出码是否仍为 `0xc0000005`。

该改动只解除“策略性拒绝”，不解决注入检测、附加拒绝或时序问题；后续步骤中仍应把这两类因素分开判断。

### 覆盖后首次运行的观察

时间：2026-09-27 23:17:48–23:18:14。目录：`E:\pfrenderdoc-captures\20260927-231745`（其中只有 `diagnostic.log`，无 `.rdc`，无崩溃 dump）。

成功点（覆盖已生效且设备被接管）：

- 第 29 行出现新的覆盖日志：`Application requested not to be hooked via ... - ignoring and hooking anyway.`
- 第 30–34 行表明设备确实被包装：`Adding D3D11 device frame capturer for 0x0000017F78591770`、`New D3D11 device created: nVidia / NVIDIA GeForce RTX 4070 32.0.16.1714`，随后针对设备与交换链再次注册 frame capturer。
- 第 32–33 行的 `ID3D11Device2/Context2 ... tiled resources are not supported` 是既有告警，与本问题无关。
- 第 35 行 `Created wrapped D3D11 device.` 来自上游 `SUCCEEDED(ret)` 且调用方未传 `ppDevice` 的分支（该文案与实际含义不符），说明期间还有一次不产生输出设备的创建调用，未包装。不能把它读作“设备已包装”。

失败点：

- 目标进程 23:18:14 以 `0xc0000005` 退出。Application 日志中对应一条 `Application Error`（23:18:09，PID `0x7660` = 30304），异常码 `0xc0000005`，`Fault offset: 0x00007fff92f56f67`，`Faulting module name: unknown`。

地址归属（无需管理员即可验证）：

- 本次 boot（2026-09-24 20:21）内 `ntdll.dll` 在 explorer 与 powershell 中基址一致，均为 `0x7fff92ee0000`；系统映像基址在同一 boot 内跨进程共享。因此该地址落在 ntdll 内：`ntdll.dll + 0x76f67`。
- 用 dumpbin 解析 ntdll 导出：前一个导出是 `RtlVirtualUnwind2`（RVA 0x75ef0，即 +0x1077），下一个导出在 RVA 0x78f50。崩溃位于 ntdll 的**异常/栈展开代码区**，而不是任何游戏模块或注入模块。

跨运行对比（全部在同一 boot 内）：

| 时间 | 场景 | Fault offset | WER 崩溃报告 |
| --- | --- | --- | --- |
| 21:02 | 注入、无调试器、设备未被包装 | 未产生报告（仅退出码 `0xc0000005`） | 无 |
| 21:10–21:11 | ProcDump 三次 | `0x00007ff7cc324874`（EXE 区） | 有 |
| 21:22 | CDB 附加 | `0x00007fff92f56f67` | 有 |
| 23:18 | 本次：设备已被包装 | `0x00007fff92f56f67` | 有 |
| 23:24 | 用户侧另一次运行 | `0x00007fff92f56f67` | 有 |
| 23:33 | 提权脚本运行，设备已被包装 | `0x00007fff92f56f67` | 有 |

结论：

- 已确认：本次覆盖生效，D3D11 设备与交换链已被接管；“应用程序请求不要 hook”不再是卡点。
- 已确认：23:18 与 21:22 两次崩溃落在**同一条 ntdll 指令地址**上，两次的差别是“是否包装设备、是否附调试器”。因此该 AV 与设备包装无关，是确定性、可复现的失败签名。本次改动把存活时间从约 5 s 延长到约 21 s，但没有改变失败签名。
- 推断（尚未验证）：WER 报 `Faulting module name: unknown`，而按基址共享可算出它在 ntdll。这通常意味着崩溃进程的模块链表对报告器不可解析（被摘链或篡改）。结合此类内核反作弊的已知行为，较可能的路径是反作弊在做栈回溯或异常处理时于 ntdll 的展开代码中触发 AV。这是假设，不是结论。
- 排除项：`BlueScreen` / `LiveKernelEvent` 的 WER 1001 条目是排队的历史报告；本 boot 未重启，System 日志中同期也没有显示驱动 TDR 事件，不应把它们当作本次故障。

本题之后可按信息量排序的最小下一步：

1. 取 dump：从 `Application Error` 事件里拿到新的 ReportArchive 目录，用管理员复制 `Report.wer`，并为 `YuanShen.exe` 配置 `LocalDumps`（`DumpType=2`）以取得完整 dump，再用 CDB 跑 `!analyze -v`、`~*k` 判断是哪个线程与哪个调用者进入 ntdll 展开代码。
2. 对照实验：在 `LibraryHooks::RegisterHooks()` 前加一个环境变量开关，使 DLL 注入但不安装任何 hook，判断崩溃由“模块存在”还是“hook 存在”引起。
3. 在约 20 s 的存活窗口内按 F12（或 PrintScreen，见 `core.cpp` 中 `m_CaptureKeys` 默认值）触发一次截帧，确认能否落盘 `.rdc`；即使随后崩溃，已落盘的帧仍有分析价值。

#### 取崩溃 dump 的具体步骤

前置事实：这台机器 `HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps` 已有多个按应用名分列的子键（NVIDIA 组件、HD-Player 等），`HKCU` 下没有 LocalDumps，因此按同样的 HKLM 约定为 `YuanShen.exe` 添加子键即可生效。RenderDoc 自带的 breakpad 崩溃处理在当前构建中不可用：`core/crash_handler.h` 第 27 行要求 `RENDERDOC_OFFICIAL_BUILD`，非官方构建下 `RDOC_CRASH_HANDLER` 为 OFF，这也是 `%TEMP%\RenderTest\dumps` 从未出现的原因。

风险提示：21:21 的 CDB 会话中 `.dump /ma` 返回 `0x80070005`，即对目标进程的内存读取被拒绝。WerFault 也可能被同样拦截，因此流程中包含一次“可 dump 性”验证，避免整轮运行只得到“没有 dump”这一种结论。

步骤（均在管理员 PowerShell 中）：

1. 一次性配置 LocalDumps（`DumpType=1` 为 mini，已含线程栈与模块表；`2` 为全量，对游戏可能是数 GB）：

   ```powershell
   $k = 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\YuanShen.exe'
   New-Item -Path $k -Force | Out-Null
   New-Item -ItemType Directory -Path 'E:\pfrenderdoc-captures\dumps' -Force | Out-Null
   New-ItemProperty -Path $k -Name DumpFolder -PropertyType ExpandString -Value 'E:\pfrenderdoc-captures\dumps' -Force | Out-Null
   New-ItemProperty -Path $k -Name DumpType   -PropertyType DWord -Value 1 -Force | Out-Null
   New-ItemProperty -Path $k -Name DumpCount  -PropertyType DWord -Value 5 -Force | Out-Null
   ```

2. 照原流程跑一次截帧。

3. 目标存活期间（约 20 s 窗口内）在另一个管理员窗口验证“进程能否被读取”，同时留一份存活快照：

   ```powershell
   $p = Get-Process YuanShen -ErrorAction Stop
   & 'C:\Program Files\Procdump\procdump64.exe' -accepteula -ma $p.Id "E:\pfrenderdoc-captures\dumps\live_$($p.Id).dmp"
   ```

   成功说明内存可读，WER 路线大概率能出崩溃 dump；失败则记录错误码，改走备用方案。

4. 进程退出后检查 `E:\pfrenderdoc-captures\dumps` 是否出现 `YuanShen.exe.<pid>.dmp`。

5. 分析完成后清理：

   ```powershell
   Remove-Item 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting\LocalDumps\YuanShen.exe' -Recurse -Force
   ```

备用方案（若第 3、4 步都拿不到 dump）：其一，为构建定义 `RENDERDOC_OFFICIAL_BUILD` 以启用自带 breakpad 处理，dump 由独立进程写入 `%TEMP%\RenderTest\dumps`，比 WerFault 更可能绕开读限制，但会同时启用 official build 的其他分支；其二，在截帧 DLL 内为被注入进程注册自己的 `SetUnhandledExceptionFilter` 与 `MiniDumpWriteDump`，把 dump 直接写到 capture 目录。

#### 跨进程 dump 已被证伪，改为进程内自 dump

时间：2026-09-27 23:32–23:36。

- 23:32 那次运行（`20260927-233225`）在提权后跑完：HKLM 的 LocalDumps 子键写入成功（提权生效的证据），设备于 23:33:32 再次被成功包装，目标仍以同一 offset `0x00007fff92f56f67` 退出（23:33:54，PID `0x4534`），`dumps` 目录为空。
- 受控对照实验（不需要管理员）：用 csc 编译一个空指针解引用的 64 位程序，**命名为 `YuanShen.exe`** 后运行，退出码同为 `0xc0000005`，WER 立刻在配置的 `DumpFolder` 写出 `YuanShen.exe.46244.dmp`（6011036 字节）。结论：LocalDumps 配置本身正确且生效，游戏进程没有 dump 只能归因于保护组件拒绝 WerFault 读取其内存；这与 21:21 CDB `.dump /ma` 的 `0x80070005` 相互印证。
- 由此确定：WerFault 对该目标写不出 dump；但**跨进程读取本身并未被完全封死**——23:35 那轮里，提权脚本的守候作业用 `procdump -ma <pid>` 成功抓到了存活目标的完整 dump（`live_7756.dmp`，603722337 字节，procdump 日志记录 “590 MB written in 0.6 seconds”）。因此后续判断应以“WerFault 被拒”为准，不能推广成“所有跨进程 dump 都不行”。
- 实现：在 `renderdoc/os/win32/win32_libentry.cpp` 中，于 `RenderDoc::Inst().Initialise()` 之后、`LibraryHooks::RegisterHooks()` 之前安装两个处理器——`AddVectoredExceptionHandler(1, ...)` 记录每个 `0xc0000005` 的一手信息（含地址是否落在 ntdll 内），`SetUnhandledExceptionFilter(...)` 写 mini dump。为避免崩溃线程可能正持有日志锁而导致死锁，这两个处理器**不使用 RenderDoc 日志系统**，改用 Win32 直接追加到 `<日志路径>.crash.txt`；dump 写到 `<日志路径>.unhandled.dmp` 与 `<日志路径>.firstchance.dmp`。`MiniDumpWriteDump` 经 `LoadLibrary` + `GetProcAddress` 获取，因此不新增链接依赖，也把 dbghelp/dbgcore 的加载推迟到崩溃时刻。
- 覆盖策略：除未处理异常外，当一手 AV 的地址落在 ntdll 内（即已观察到的签名）时，也从 VEH 直接写一份 dump，以防未处理异常过滤器被反作弊替换。
- 运行期注意：自 dump 文件与 `diagnostic.log` 同目录，便于按轮次归档；`dumps` 目录的 LocalDumps 配置保留为兜底。
- 附带修正：`run-capture-with-dump.ps1` 首版存在时序错误——它在启动游戏**之前**就等待并杀掉 live dump 的守候作业，导致该轮 live dump 被跳过。已改为先启动截帧、再等待守候作业。

#### 一手异常已被捕获，minidump 写入自身失败

时间：2026-09-27 23:35:56–23:36:25，目录 `20260927-233556`。

- 新构建的 DLL 确实被加载：日志中 `win32_libentry.cpp` 的行号由 71/73/75 变为 250/256/258。
- 自 dump 处理器安装成功：`%TEMP%\RenderTest\RenderDoc_app_2026.09.27_23.35.58.log.crash.txt` 内容为 `self-dump handlers installed: pid=7756`。
- 崩溃瞬间的记录（同一进程，日志基名不同）：`first-chance AV: pid=7756 thread=37376 addr=00007FFF92F56F67 in-ntdll=1`，紧接一行 `firstchance: MiniDumpWriteDump failed - error 2147943398`（`0x800703E6`，Win32 998 `ERROR_NOACCESS`）。
- 由此确认三点：其一，该崩溃是**真实的一手访问违例**，故障地址落在 ntdll 内，与 21:22、23:18、23:24、23:33 四次 WER 记录的 offset 完全一致；其二，`MiniDumpWriteDump` 在进程内同样会失败，因为它也需要展开这些栈，而崩溃点正在 ntdll 的展开代码里；其三，本次没有出现 `unhandled exception:` 记录，说明该异常在到达未处理过滤器之前就被接管，或该过滤器已被替换。
- 相关性证据：22:25 那次“只附加调试器、不注入截帧 DLL”的对照中，目标在 45 秒观察窗后仍在运行；而所有注入了截帧 DLL 的运行都在设备创建后约 22 秒内以同一 offset 退出。触发条件与注入模块的存在相关，与“是否包装设备”无关。
- 运行环境调整：`run-capture-with-dump.ps1` 现在设置 `RDC_SELFDUMP_DIR`，自 dump 产物统一落到 `E:\pfrenderdoc-captures\dumps`。
- 代码相应改为**不依赖栈展开**的 raw dump：记录寄存器上下文、异常参数（含 AV 的目标地址与读/写/执行类型）、模块表（Toolhelp32）、`Rsp` 处原始栈窗口，并对 256 KB 栈区扫描“返回地址候选”并按模块基址+大小归属。`MiniDumpWriteDump` 降级为最小 flags 的尽力而为。

#### raw dump 结果：故障发生在反作弊自身的线程上

时间：2026-09-27 23:39:46，产物 `E:\pfrenderdoc-captures\dumps\selfdump_29304.firstchance.raw.txt`（18245 字节）与同名 `.crash.txt`。

异常本体：

- `code=0xc0000005 flags=0x00000000 address=00007FFF92F56F67 params=2`，`param[0]=1`、`param[1]=0`，即 **写访问违例，目标地址为 NULL**。
- `rip in module: ntdll.dll + 0x76f67`，与四次 WER 记录的 offset 完全一致；该 RVA 位于 ntdll 导出 `RtlVirtualUnwind2`（RVA 0x75ef0）之后 +0x1077 处、下一个导出 0x78f50 之前，属异常/栈展开代码区。
- 上下文：`rsp=0x20cbafe890`、`rbp=0`、`rax=0`、`rdx=0`、`rsi=0`、`r12=1`，且 `rdi/rbx/r8/r9/r13` 全部指向 MHYPBase.dll 内部（`r13` 即 MHYPBase 基址）。

线程与调用链：

- 故障线程 `tid=33688`，栈底可见 `KERNEL32.DLL + 0x2e8d7`（`BaseThreadInitThunk`）与 `ntdll.dll + 0x3c34c`（`RtlUserThreadStart`），说明这是**由 CreateThread 启动的工作线程**，不是主线程。
- 该线程栈上的返回地址候选几乎全部属于 **MHYPBase.dll**（+0x67f95、+0x19807c2、+0x1a15ff0、+0xc55268、+0x640b5c、+0xae16d、+0x176dee、+0x176dd0，其中若干地址在多个栈位置重复出现），另有 ntdll 的 +0xdf434、+0x7fb00、+0x81d60、+0x7fdd1、+0x7b120、+0x929fd、+0x3c34c 与 KERNEL32 的 +0x28cf8、+0x28cc0。
- 139 个模块中可见 `rendertest.dll`（基址 `0x7ffe4f050000`，大小 `0x17e5000`）、`MHYPBase.dll`（`0x7ffe4d610000`，`0x1a33000`）、`HoYoChannel.dll`、`MiHoYoMTRSDK.dll`。**候选返回地址里没有任何 rendertest.dll 的帧**。

据此可以确立（以及仍需保留为假设的部分）：

- 已确立：致命事件是真实的写 NULL 访问违例，位于 ntdll 的展开代码区，发生在一个属于反作弊模块代码路径的工作线程上；它与“是否包装 D3D11 设备”无关，且只在注入截帧 DLL 的情况下出现（22:25 无注入对照中目标 45 秒后仍存活）。
- 已确立：进程内 `MiniDumpWriteDump` 即便改用最小 flags 仍以同一错误 998 失败，说明该失败与 flags 无关，而是与崩溃点所处的展开路径有关；raw dump 是可靠替代。
- 仍属假设：该违例是反作弊在检测到注入模块后**主动构造的自毁**，还是其栈回溯路径在遇到外来模块时**意外传入了 NULL 上下文/出参**。两条都能解释“固定 offset + 写 NULL + 无未处理异常记录”，目前证据不足以区分。
- 待验证：本次 `crash.txt` 中没有出现 `unhandled exception:` 行，说明该一手异常在到达未处理过滤器之前就被接管，或过滤器已被替换。

#### hook 组二分：硬杀由 D3D 导入补丁触发，与对象替换无关

时间：2026-09-27 23:43–23:58。为此在源码中加入按环境变量开关的二分点（`RDC_NO_HOOKS`、`RDC_NO_WIN32_HOOKS`、`RDC_NO_D3D_HOOKS`、`RDC_NO_WRAP`、`RDC_REDIRECT_NULL_WRITE`），并由 `run-capture-with-dump.ps1` 的对应开关驱动。

| 模式 | 存活 | 退出方式 | ntdll tripwire |
| --- | --- | --- | --- |
| 全部 hook（原样） | ~22 s | `0xc0000005` + WER 报告 | 出现 |
| 仅关 Win32 组 | ~23 s | `0xc0000005` + WER 报告 | 出现 |
| 保留 IAT 补丁、取消对象替换 | ~30 s | `0xc0000005` + WER 报告 | 出现 |
| 关 D3D11/DXGI 组 | ~77 s | `0x00000000`，无 WER 报告 | 未出现 |
| 全部关闭 | ~64–67 s | `0x00000000`，无 WER 报告 | 未出现 |

结论：

- 硬杀（即那个写 NULL 的 ntdll 一手异常）由 **D3D11/DXGI 的导入表补丁**触发；设备、工厂、交换链等**对象替换本身没有被检测**——取消替换后仍在 ~30 s 被同一签名杀掉。
- 关闭该组后仍有第二层检测：注入模块存在本身会在约 70 秒后导致一次 `exit 0` 的温和退出（无 WER 报告、无 AV）。22:25 的无注入对照可存活 45 秒以上，因此这一层也与注入相关。
- 因此若要同时保住截帧与存活，正确方向是改交付方式：使用 **`d3d11.dll` 代理**（GIMI/3DMigoto 路线），让加载器把游戏的 `d3d11` 导入解析到代理，从而完全不修改游戏导入表；代理再把创建好的设备与交换链交给 RenderDoc 的包装路径（包装已验证不被检测）。这条路线的实证支持是：该反作弊长期容忍同类的 d3d11 代理 mod。
- 过程修正：`RDC_NO_WRAP` 首版实验无效——上游对真实调用传入 `ppImmediateContext = NULL` 并由包装路径回填，而我的 no-wrap 分支未回填，导致目标在 `YuanShen.exe` 内读 NULL 于 1 秒内崩溃。已在 `d3d11_hooks.cpp` 的 no-wrap 分支补上 `GetImmediateContext` 回填后重测，表中数据为修正后结果。

#### 自动截帧已可用：无需手速，窗口内稳定产出有效 `.rdc`

时间：2026-09-28 00:12–00:17。这是原"约 20 秒窗口 + 自动截帧"退路的落地与验证。

实现（`renderdoc/os/win32/win32_libentry.cpp`，已同步到构建工作区并重编）：

- 新增 `ScheduleAutoCapture()`，在 `LibraryHooks::RegisterHooks()` 之后调用（`RDC_NO_HOOKS=1` 时与 hook 一起跳过）。两路触发互相独立、可叠加：
  - `RDC_AUTO_CAPTURE_FRAME`：逗号/空格分隔的帧号列表，逐个调用 `RenderDoc::Inst().QueueCapture(N)`。帧号取自被包装设备自己的计数器（该设备第一次 Present 为第 1 帧，见 `d3d11_device.cpp:2730`），因此无论加载多久，都在"确实呈现过 N 帧"后才触发。
  - `RDC_AUTO_CAPTURE_DELAY_MS`：逗号/空格分隔的毫秒延迟列表，由一次性 `CreateThread` 建的工作线程按升序 `Sleep` 后调用 `TriggerCapture(1)`，作为"帧号永远到不了"时的墙钟兜底。
- 解析在 DLL 内完成（`ParseUintList`），脚本只负责原样传字符串；每个解析出的值都会各打一条 `RDCLOG`，便于事后核对是否被误解析。
- `run-capture-with-dump.ps1` 新增 `-AutoCaptureFrame` / `-AutoCaptureDelayMs`（默认 `'3000 12000'` / `'9000 16000'`），随提权重启参数一起透传。

构建与产物核对：`E:\pfrenderdoc-build\build-logs\auto-capture-x64.log`，Build succeeded；`rendertest.dll` 24579072 字节（2026-09-28 00:12），内含 `RDC_AUTO_CAPTURE_FRAME`、`RDC_AUTO_CAPTURE_DELAY_MS` 等字符串。

第一轮（`20260928-001444`，`-SkipLiveDump`）：

- 注入 00:14:46，D3D11 设备与交换链于 00:14:51 被包装，00:14:58 触发截帧，00:15:12 以 `0xc0000005` 退出（同一 offset `0x00007fff92f56f67`，自 dump 同步生成）。
- 产出 `YuanShen_frame17053.rdc`（559770 字节）。
- **发现一个参数解析缺陷**：日志显示 `QueueCapture(300600) armed`。原因是脚本把帧列表以 `300,600` 交给 `[int[]]` 参数，而在 zh-CN 区域设置下逗号是千位分隔符，`"300,600"` 被解析成单个数 300600，因此该路触发不可能命中（游戏只渲染到约 1.7 万帧）。本轮实际生效的只有墙钟那一份。**已修正**：脚本参数改为 `[string]`（空格分隔、原样透传），DLL 侧解析不变。

第二轮（`20260928-001631`，`-SkipLiveDump`，参数 `frames='3000 12000' delays='9000 16000'`）：

- 注入 00:16:33，两路均按预期工作，日志中帧号被正确拆成两条 `QueueCapture(3000)` / `QueueCapture(12000)`。
- 产出 4 个 `.rdc`：`frame3000`（411297 B，触发于 00:16:38）、`frame12000`（370738 B）、`frame13197`（208613 B，墙钟 9 s）、`frame31928`（1690192 B，墙钟 16 s）。
- 00:16:59 以同一签名 `0xc0000005` 退出；自 dump 正常。

验证（不依赖 GUI，产物在 `E:\pfrenderdoc\build-logs\autocapture-verify`）：

- `rendertestcmd thumb <rdc> -o <png> -f png -s 512` 对 4 个 `.rdc` 全部成功，抽出缩略图。
- 缩略图内容（逐张查看）：`frame3000` 为 miHoYo logo；`frame12000` 与 `frame13197` 均为近白过渡帧（后者带淡出的 logo 轮廓）；`frame31928` 为健康警告页"警告：游戏前详阅"，是信息量最大的一份。加上第一轮的 `frame17053`（原神 logo + 版号/出版信息），全部 5 份都在启动前段的法律/品牌画面内。
- `rendertestcmd replay <rdc> -l 1` 对 `frame17053` 与 `frame31928` 均返回 0 且无错误输出，说明帧可完整回放。

结论与影响：

- 自动截帧这条路**技术上已经通了**：不需要手速、不需要人在键盘前，每轮都能拿到可抽帧、可回放的 `.rdc`。这一段可以直接作为后续任何实验的常规取证手段。
- 但它在**内容上不解决问题**：22–26 秒的存活窗口只够走完启动前段的 logo 与健康警告，取不到实际游戏画面。因此"接受 20 秒窗口"不能替代代理方案——它只保证"有帧"，不保证"有要分析的帧"。
- 顺带确认的时序数据（供后续估算窗口）：注入→图形层接管约 5 s；前段画面帧率极高（约 1400 fps，00:16:38 已达第 3000 帧、16 s 时第 31928 帧），所以帧号与前段画面位置的关系非常不稳定，**按时间触发比按帧号触发更可控**。

#### 交换链来源侦察：`CreateDXGIFactory` + `IDXGIFactory::CreateSwapChain`

时间：2026-09-28 00:20–00:25。方法：纯静态分析，不需要运行目标、不需要管理员、不需要重启游戏。

全安装目录 520 个二进制（511 个 `.dll` + 9 个 `.exe`）字符串扫描 + 关键模块 `dumpbin /imports`：

| 入口点 | 命中 |
| --- | --- |
| `D3D11CreateDeviceAndSwapChain` | **全树 0 命中** |
| `D3D11CreateDevice` | `YuanShen.exe`；另有 `zf_cef.dll`、`libGLESv2.dll`、`AccountPlatNative.dll`（浏览器/ANGLE 类插件，与本游戏渲染链路无关） |
| `CreateDXGIFactory`（及 `1` / `2`） | `mhypbase.dll`、`YuanShen.exe` |

`dumpbin /imports` 细节：

- `YuanShen.exe`：导入表里**没有 `d3d11.dll`，也没有 `dxgi.dll`**——只链 KERNEL32/USER32/OPENGL32/dbghelp 等。d3d11 与 dxgi 全部经由 `LoadLibrary` + `GetProcAddress` 动态解析。
- `mhypbase.dll`：从 `dxgi.dll` **只导入一个符号**——普通（非 delay-load）Import Address Table 中的 `CreateDXGIFactory`（表项 RVA `0x180681ED8`）；不导入 `d3d11.dll` 任何符号。
- `rtlbase.dll`：两者皆无。

结论（已确立）：交换链**不是**经 `D3D11CreateDeviceAndSwapChain` 创建，而是先 `CreateDXGIFactory*` 取得工厂、再在工厂对象上调用 `CreateSwapChain`。该调用是 COM vtable 调用，不会出现在导入表里，因此只能由"入口点存在性 + 组合入口点彻底缺席"反推。

对代理方案的影响（重要修正）：

- **只做 `d3d11.dll` 代理不够**。代理能拦到设备创建，但交换链由游戏在工厂对象上以 vtable 调用创建，`d3d11.dll` 代理永远看不到这一步。
- RenderDoc 只在 `WrappedIDXGIFactory::CreateSwapChain` 里包装交换链，且要求 `GetD3DDevice(pDevice)` 能解析出已包装的设备（`dxgi_wrapped.cpp:1231-1265`）；否则它会 `RDCERR("Creating swap chain with non-hooked device!")` 并原样放行。设备包上了、交换链没包上，等于没有截帧。
- 因此代理交付必须**两侧同时覆盖**：`dxgi.dll` 代理（包装 `CreateDXGIFactory*`，返回我们自己的工厂对象）+ 设备侧包装入口。原计划第 3 步由"若…则需要"升级为**必需**。

由此得到的一条更尖的假设（与已有二分结果一致）：

- RenderDoc 的 IAT 补丁会改写**所有**已加载模块中该函数的导入项；忽略名单只有 Windows 组件与显卡驱动模块（`win32_hook.cpp:267-279`），`mhypbase.dll` 不在其中。
- 而 `mhypbase.dll` 自己的导入表里就有 `CreateDXGIFactory`，该函数正被 DXGI hook 注册（`dxgi_hooks.cpp:265`）。也就是说，D3D 组一旦启用，**我们就把这个反作弊模块自己的导入表项改指向了 `rendertest.dll`**。
- 旁证与边界：`LoadLibrary*` / `GetProcAddress` 的 IAT 补丁属于 hook 基础设施（`win32_hook.cpp:884-911`），只要注册了任何 hook 就会安装，不受 `RDC_NO_WIN32_HOOKS` / `RDC_NO_D3D_HOOKS` 控制。而"关 D3D 组"那一轮（存活约 77 s、无 ntdll tripwire）里这些补丁同样生效却不再被硬杀。所以"反作弊看见自己 IAT 里有个外来指针"这一条**不足以**单独解释硬杀。
- 真正与硬杀对应的是 D3D 组，而组内最可能的具体一项是 `CreateDXGIFactory` 的补丁：d3d11 侧的补丁只可能落在导入 `d3d11.dll` 的模块上，也就是 `zf_cef.dll`、`libGLESv2.dll`、`AccountPlatNative.dll` 这些与渲染链路无关的插件；唯一落在核心链路上的，就是 `mhypbase.dll` 与动态解析路径上的 `CreateDXGIFactory`。
- 该假设尚未验证。最便宜的验证：把现有 `RDC_NO_D3D_HOOKS` 再拆成 dxgi-only / d3d11-only 两个开关，或直接让 IAT 补丁跳过 `mhypbase.dll`，然后重跑二分表里对应的格子。

证据文件：`E:\pfrenderdoc\build-logs\recon\YuanShen-imports.txt`、`mhypbase-imports.txt`、`rtlbase-imports.txt`。

#### IAT 补丁范围二分：跳过 `mhypbase.dll` 即可同时保住截帧与存活

时间：2026-09-28 00:28–00:45。目的：把"硬杀由 D3D 导入补丁触发"收窄到**具体哪个补丁、落在哪个模块**，并拿到可用配置。

新增开关（源码与构建工作区已同步重编，`rendertest.dll` 24580096 字节 / 00:32:44，构建日志 `E:\pfrenderdoc-build\build-logs\iat-scope-bisect-x64.log`）：

| 开关 | 作用 | 实现位置 |
| --- | --- | --- |
| `RDC_NO_DXGI_HOOKS` | 只关 DXGI 组 | `dxgi_hooks.cpp`，`DXGIHook::RegisterHooks` |
| `RDC_NO_D3D11_HOOKS` | 只关 D3D11 组 | `d3d11_hooks.cpp`，`D3D11Hook::RegisterHooks` |
| `RDC_NO_D3D_HOOKS` | 两组同关（原粗开关，保留以便早期结果可复现） | 同上两处 |
| `RDC_SKIP_IAT_MODULE` | 逗号分隔模块名，**不改写这些模块的导入表** | `win32_libentry.cpp`，`IatScopeHook` |

实现要点：`RDC_SKIP_IAT_MODULE` **不能**在 `add_hooks()` 里直接调 `LibraryHooks::IgnoreLibrary()`——它写入的 `s_HookData` 要等 `BeginHookRegistration()` 才分配（`win32_hook.cpp:878-882`），提前调用会空指针。因此改用一个 `LibraryHook` 子类，在 hook 注册流程内部生效。

扫描（`run-bisect.ps1`，一次提权连跑三个模式，汇总在 `bisect-20260928-003329.txt`）：

| 模式 | d3d11 组 | dxgi 组 | mhypbase IAT | 结果 |
| --- | --- | --- | --- | --- |
| `skipiat-mhypbase` | 开 | 开 | **未改写** | **无 AV，退出码 `0x00000000`，存活 79 s，5 个 `.rdc`（含 86 MB 游戏内帧）** |
| `no-dxgi-hooks` | 开 | 关 | 不适用 | **配置自身错误，数据作废**：5 s 内在 `dxgi.dll+0x37686` 读 `0xFFFFFFFFFFFFFFFF` 崩溃 |
| `no-d3d11-hooks` | 关 | 开 | 被改写 | 26 s 后 ntdll tripwire `0x7fff92f56f67`，无 `.rdc` |

`no-dxgi-hooks` 这一格必须排除：它的崩溃地址在 `dxgi.dll` 内、读 `-1`，与反作弊那条"ntdll 内写 NULL"签名**完全不同**。原因是设备被 D3D11 组包装了、而工厂没有包装，游戏于是把**包装后的设备**交给真实工厂的 `CreateSwapChain`，走进 RenderDoc 不支持的组合（`dxgi_wrapped.cpp:1308` 的 `Creating swap chain with non-hooked device!` 就是同一机制在反向配置下的表现）。**结论：两个 hook 组不能只开一个。**

由此得到的关键对照：在原样全开与 `skipiat-mhypbase` 之间，**唯一变量就是 `mhypbase.dll` 的导入表有没有被改写**。全开时该死则死，跳过它则 AV 完全消失。因此先前那条假设得到证实：**硬杀来自我们把 `mhypbase.dll` 自己的 `CreateDXGIFactory` 导入项改指向 `rendertest.dll`**，与设备/交换链包装无关（与 `RDC_NO_WRAP` 的结果一致）。

#### 工作配置已复现：存活 130 s 并取到真实游戏画面

时间：2026-09-28 00:38:37–00:40:52。目录 `20260928-003840`，配置 `-SkipIatModule mhypbase.dll`，触发点改为注入后 20/45/65 s。

- 注入 00:38:42（PID 17240），**00:40:52 以 `0x00000000` 退出，存活 130 s**（上一轮同配置为 79 s，说明第二层"温和退出"的时机有波动）。
- `selfdump_17240.crash.txt` 只有 `handlers installed` 一行——**全程无任何 AV**。
- 产出 5 个 `.rdc`：`frame0`（145 KB）、`frame32606`（112 MB）、`frame33966`（113 MB）、`frame34745`（492 MB）、`frame36658`（483 MB）。本轮占盘 1.17 GB。
- 缩略图确认内容：`frame34745` 是**完整游戏画面**——角色立于璃月城内，含 NPC、队伍列表、小地图与 HUD；即目标完成标准中的"实际渲染画面"。
- `thumb` 对 5 份全部成功；`rendertestcmd replay -l 1` 对 492 MB 的 `frame34745` 返回 0，可完整回放。

两处容易误读的地方，已核实：

1. **`result.txt` 里的 Application Error 是假阳性。** 该文件中的 `Fault offset: 0x00007fff92f56f67`、`PID 0x3F88`（=16264）来自**上一轮 `no-d3d11-hooks`**：脚本用 `StartTime=(Get-Date).AddMinutes(-10)` 捞事件，而本轮干净退出、自己没有 WER 事件，于是把 10 分钟内最近的旧事件写了进去。判断本轮是否被杀，应以 `selfdump_<本轮PID>.crash.txt` 与诊断日志的退出码为准。
2. **`frame0` 与"无触发日志的那次截帧"都有明确来源。** `WrappedIDXGI...` 侧新建交换链时会调用 `WrappedID3D11Device::FirstFrame`，其中 `ShouldTriggerCapture(0)`（`d3d11_device.cpp:2673-2685`）——这就是 `QueueCapture(0)` 能命中的原因。而多出来的那次截帧来自 `RenderDoc::Tick()` 的截帧热键检查（`core.cpp:1211-1214`，`d3d11_device.cpp:2723` 每个 Present 调用）：它触发时**不打任何日志**。热键判定用 `GetAsyncKeyState(vk) != 0`（`win32_stringio.cpp:141`），而该返回值的最低位表示"自上次调用以来按过该键"，因此一次 F12/PrintScreen 事件（或 VK_SNAPSHOT 的系统性闩锁）就会多出一次截帧。两轮各多一次，属既有功能而非本次改动引入；顺带说明这也是模式 1 之所以能意外抓到游戏内帧的原因。

#### 结论改写：代理方案不再是主线的唯一出路

- 原计划的 `d3d11.dll` + `dxgi.dll` 代理（不碰任何导入表）在原理上仍然成立，但**已不必作为第一步**：`RDC_SKIP_IAT_MODULE=mhypbase.dll` 已经在保留全部 hook 的前提下消除了硬杀。
- 当前剩下的唯一瓶颈是**第二层"温和退出"**（无 AV、无 WER、`exit 0`），实测在 79–130 s 之间浮动。它决定了窗口长度，而不是能否截帧。
- 因此"取到多少画面"现在只取决于窗口长度：130 s 已足够进入游戏世界（本轮 65 s 的触发点即拿到城内画面）。

#### GUI 路径（`rendertestui.exe`）：不需要改代码，只需把开关送进目标

时间：2026-09-28 00:50–01:00。用户要求在 `E:\pfrenderdoc-build\x64\Release\rendertestui.exe` 启动的流程下也能截帧。

排查结论：**GUI 与 CLI 走的是同一套注入与 Hook 代码，差别只在开关怎么传。**

- `rendertestui.exe` 只是 `CreateProcessW("qrendertest.exe …", lpEnvironment=NULL)`（`renderdocui_stub.cpp:73`），继承环境；真正的界面是 `qrendertest.exe`。
- GUI 启动目标经 `RENDERDOC_ExecuteAndInject` → 同一个 `LaunchAndInjectIntoProcess`；注入的 DLL 由 `GetModuleHandleA("rendertest.dll")` 解析（`win32_process.cpp:615`），也就是 GUI 自己加载的那份，即我们一直在编的 `rendertest.dll`。不存在"注入了另一个 RenderDoc"的风险。
- 差别在环境：`rendertestcmd capture` 传**空**的 env 列表、完全靠 shell 继承（`renderdoccmd.cpp:256`）；GUI 传的是启动对话框 **Environment Variables** 区的列表（`CaptureDialog.ui:145`、`EnvironmentEditor`），并随 exe 记入设置（`CaptureDialog.cpp:919` 读 `settings.environment`）。从资源管理器双击 GUI 时该列表为空，于是落回默认行为——改写 `mhypbase.dll` 的 IAT——22–26 秒被硬杀。
- 现场证据：`%APPDATA%\qrendertest\UI.config` 中 `LastCaptureExe=YuanShen.exe`、`LastCapturePath` 已指向游戏目录，而 **`RecentCaptureSettings` 为空**，即此前从 GUI 启动时没有带任何开关。

处理：新增 `E:\pfrenderdoc-captures\run-rendertestui.ps1`——自提权（目标拒绝非提权启动，Win32 740）、设置 `RDC_SKIP_IAT_MODULE=mhypbase.dll` 与可选自动截帧、清掉可能残留的其他 `RDC_NO_*` 开关、启动 GUI，并打印截帧落盘位置与注意事项。**不需要改动 RenderDoc 源码。**

GUI 路径的四个注意事项：

1. **必须提权**：目标普通权限启动报 740；GUI 不像 `run-capture-with-dump.ps1` 会自提权。
2. **截帧先落到临时目录**：`TemporaryCaptureDirectory` 为空时是 `%TEMP%\RenderTest\<App>_<UTC时间>.rdc`（`CaptureContext.cpp:281-299`）。要固定位置，可在 GUI 里设 `DefaultCaptureSaveDirectory`。
3. **别开 "Reference All Resources" / "Capture Callstacks"**：CLI 那几轮是 `refAllResources=false`（"Serialised 180 resources, skipped 1070 unreferenced"），已是 100–500 MB 量级。
4. **不要用"注入到已运行进程"**：那条路径的环境变量是在 DLL 加载**之后**才由 `INTERNAL_ApplyEnvMods` 写入目标（`win32_process.cpp:247-250`），而 hook 注册发生在 DllMain、更早，因此 `RDC_SKIP_IAT_MODULE` 不会生效。只能走"启动并注入"。

GUI 自带的触发手段（无需环境变量）：F12 / PrintScreen，以及 Live Capture 窗口的 **Queue Capture**（按帧号，`LiveCapture.cpp:283`）。按帧号不稳（前段约 1400–1800 fps、进游戏后约 340 fps），按时间或手动更可控。

## 下一步实施方案：`d3d11.dll` 代理交付（**已降级为备用路线**）


> 状态更新（2026-09-28 00:45）：`RDC_SKIP_IAT_MODULE=mhypbase.dll` 已在保留全部 hook 的前提下消除硬杀，因此本方案**不再是主线第一步**。它仍然是不碰任何导入表的"干净"交付方式，若后续第二层检测被证明与 IAT 改写（如 `LoadLibrary`/`GetProcAddress` 那组基础设施补丁）有关，再回到这里。保留原文以备后续。



目标：在不修改游戏导入表的前提下完成同样的设备/交换链包装，从而同时保住截帧与存活。

前置结论（2026-09-28 00:25 侦察，见上文"交换链来源侦察"）：目标走 `CreateDXGIFactory*` + `IDXGIFactory::CreateSwapChain`，且**从不使用** `D3D11CreateDeviceAndSwapChain`。因此设备侧与 dxgi 工厂侧必须同时覆盖，只做 `d3d11.dll` 代理拿不到交换链。

1. **在截帧 DLL 中加导出入口**：新增一个导出（例如 `RENDERDOC_WrapExternalD3D11`），参数为代理持有的真实 `D3D11CreateDevice` 函数指针与原始调用参数；实现上直接进入 `CreateD3D11_Internal`（`d3d11_hooks.cpp:285`）的包装路径。注入后需跳过 d3d11/dxgi 两组注册（沿用已有 `RDC_NO_D3D_HOOKS` 开关）。
2. **实现 `dxgi.dll` 代理（必需的第二步，不是可选项）**：转发 dxgi 导出到真实 dxgi.dll，在 `CreateDXGIFactory` / `1` / `2` 内把返回的工厂对象换成我们自己的薄包装，使其 `CreateSwapChain` / `CreateSwapChainForHwnd` 在调用真实现后，把交换链交给截帧 DLL 包装（对应 `WrappedIDXGIFactory::CreateSwapChain` 的行为，`dxgi_wrapped.cpp:1231`）。
3. **实现 `d3d11.dll` 代理**：转发 d3d11 导出到真实 d3d11.dll；在 `D3D11CreateDevice` 内调用第 1 步的入口，使 `GetD3DDevice()` 能解析出已包装的设备，第 2 步的交换链包装才有落点。参考实现：[SeanPesce/d3d11-wrapper](https://github.com/SeanPesce/d3d11-wrapper)、[bo3b/3DMigoto](https://github.com/bo3b/3DMigoto)。
4. **部署与验收**：两个代理放入游戏目录并确保被优先加载。验收标准：（a）进程存活超过 120 秒且不出现 ntdll tripwire；（b）存活期内取到**实际游戏画面**的 `.rdc` 并能回放——启动前段的 logo 帧不算通过（自动截帧已证明这类帧很容易拿到，见上文）。

风险与前提：往游戏目录放文件本身可能触发文件完整性/黑名单检测；代理模块虽名为 `d3d11.dll`，但其路径不是 System32，仍可能被识别。若最小代理版本仍被杀，则退回到"接受约 20 秒窗口 + 自动截帧"的方案——该退路**已实现并验证**（见上文"自动截帧已可用"），但实测它只能取到启动前段的 logo 与健康警告，取不到游戏画面，所以它只是"有帧可分析"的保底，不能替代代理方案。

**可用于继续二分的开关**（在截帧 DLL 内按环境变量生效，由 `run-capture-with-dump.ps1` 的对应参数驱动）：

| 环境变量 | 脚本参数 | 作用 |
| --- | --- | --- |
| `RDC_NO_HOOKS` | `-NoHooks` | 注入但不安装任何 hook |
| `RDC_NO_WIN32_HOOKS` | `-NoWin32Hooks` | 跳过 kernel32/advapi32/ws2_32 的 IAT 补丁 |
| `RDC_NO_D3D_HOOKS` | `-NoD3DHooks` | 跳过 d3d11/dxgi 注册（同时失去截帧能力） |
| `RDC_NO_WRAP` | `-NoWrap` | 保留 IAT 补丁但不替换设备/工厂对象 |
| `RDC_REDIRECT_NULL_WRITE` | `-RedirectNullWrite` | 把 ntdll 内的空指针读/写重定向到可写页并继续执行 |
| `RDC_SELFDUMP_DIR` | 脚本自动设置 | 自 dump 产物输出目录 |
| `RDC_AUTO_CAPTURE_FRAME` | `-AutoCaptureFrame` | 帧号列表，`QueueCapture(N)` 自动截帧（默认 `'3000 12000'`） |
| `RDC_AUTO_CAPTURE_DELAY_MS` | `-AutoCaptureDelayMs` | 注入后毫秒延迟列表，`TriggerCapture(1)` 墙钟兜底（默认 `'9000 16000'`） |
| `RDC_NO_DXGI_HOOKS` | `-NoDXGIHooks` | 只跳过 dxgi 组（单独关它会因设备已包装/工厂未包装而自崩，见上文） |
| `RDC_NO_D3D11_HOOKS` | `-NoD3D11Hooks` | 只跳过 d3d11 组 |
| `RDC_SKIP_IAT_MODULE` | `-SkipIatModule` | 逗号分隔模块名，不改写其导入表。`mhypbase.dll` 为当前推荐值 |

注意：`-AutoCaptureFrame` / `-AutoCaptureDelayMs` 在脚本中是 `[string]` 而非 `[int[]]`。若改回 `[int[]]`，zh-CN 区域设置会把 `"300,600"` 当作千位分隔符解析成单个数 `300600`，该路触发会静默失效。

## 二进制与依赖检查

| 文件或服务 | 观察结果 |
| --- | --- |
| `YuanShen.exe` | 文件版本 `2017.4.30.0`；有效 Authenticode 签名，签名主体为 miHoYo Co.,Ltd.。 |
| `MHYPBase.dll` | 文件版本 `1.0.1.40413272`；产品字段 `game engine`；有效 miHoYo Co.,Ltd. 签名。 |
| `rtlbase.dll` | 描述 `engine base module`；有效 miHoYo Co.,Ltd. 签名。 |
| 安装目录中的 `HoYoKProtect.sys` | 描述 `HoYoKProtect`；公司字段 miHoYo；有效 Microsoft Windows Hardware Compatibility Publisher 签名。 |
| 系统驱动服务 `HoYoProtect` | 已注册；检查时为 Stopped / Manual；路径 `\??\C:\Windows\system32\HoYoKProtect.sys`。 |
| `YuanShen_Data\boot.config` | 内容包含 `wait-for-native-debugger=0` 与 `scripting-runtime-version=latest`。未修改。 |

重要限制：驱动检查发生在目标退出之后，停止状态不能证明它在此前运行期间未加载；也未核对安装目录与系统目录中驱动文件的哈希是否一致。模块出现和错误发生的时间接近，不能单独证明因果关系。

## 当前结论与未解决问题

已确认：

1. 致命事件是**真实的一手访问违例**：`0xc0000005`，写 NULL，位于 `ntdll.dll + 0x76f67`（`RtlVirtualUnwind2` 之后 0x1077、下一个导出 0x78f50 之前），由进程内 VEH 直接捕获，WER 记录的 offset 完全一致。
2. 该异常发生在**反作弊 `MHYPBase.dll` 的工作线程**上：线程由 `CreateThread` 启动，栈上返回地址候选几乎全属 MHYPBase.dll，而 139 个模块中不含任何截帧 DLL 的帧。
3. 触发条件是**对 `mhypbase.dll` 自己导入表的改写**：该模块从 dxgi.dll 导入 `CreateDXGIFactory`，而 RenderDoc 的 IAT 补丁会改写所有模块（忽略名单只含 Windows/显卡驱动组件）。用 `RDC_SKIP_IAT_MODULE=mhypbase.dll` 跳过它之后，AV 完全消失、存活 79–130 s；两组 hook 全开但改写该 IAT 时则必被杀。取消对象替换（`RDC_NO_WRAP`）不影响被杀，说明与包装无关。
4. 第二层检测与"截帧 DLL 存在于进程内"相关：以 `exit 0` 温和退出，无 AV、无 WER 报告，实测 65–130 s 浮动；22:25 的无注入对照可存活 45 秒以上。
5. dump 手段已摸清：WerFault 对该目标写不出 dump（LocalDumps 配置经同名受控实验验证有效），提权 `procdump -ma` 可对存活目标取到完整 dump（603 MB）；进程内 `MiniDumpWriteDump` 因崩溃点位于展开路径而以 998 失败，raw dump 是可靠替代。
6. 缓存取到**实际游戏画面**：`20260928-003840/YuanShen_frame34745.rdc`（492 MB，璃月城内），`thumb` 与 `replay -l 1` 均通过。

尚不能确认：该写 NULL 是反作弊检测后的**主动自毁**，还是其栈回溯路径**意外传入 NULL 上下文**；以及第二层"温和退出"的具体判定依据。

## 后续计划

当前主线已从"如何不被杀"转为"如何拉长窗口"：硬杀问题由 `RDC_SKIP_IAT_MODULE=mhypbase.dll` 解决，剩下的是 65–130 s 浮动的温和退出。

1. **查第二层"温和退出"的判定依据**（当前唯一瓶颈）。可行入手点：它同样只在注入存在时出现，故可继续用 `run-bisect.ps1` 扫：`-NoHooks`（已知存活约 64–67 s）、`-SkipIatModule` 再加上不同 hook 子集，比较退出时刻；同时用 raw dump 看退出前最后写入的模块/线程状态（温和退出无 AV，需另加记录点，例如 hook `ExitProcess`/`NtTerminateProcess` 记录调用栈）。
2. 若第二层一时无法绕过，则**按窗口长度安排触发点**：130 s 已足够进入游戏世界，`-AutoCaptureDelayMs '20000 45000 65000'` 的组合已验证可用。
3. `d3d11.dll` + `dxgi.dll` 代理方案降级为备用路线（见上文说明）。

已完成的步骤：无注入基线、仅附加调试器的对照（附加被拒 `0xC0000022`）、运行期只读状态检查、诊断差异核对、图形 API 接管确认与首帧截取、致命异常的进程内取证、hook 组二分定位、自动截帧落地与端到端验证、交换链来源侦察、IAT 补丁范围二分与工作配置复现。

立即可做的下一步（按信息量排序）：

1. **锚定第二层温和退出**：给温和退出加取证（hook `ExitProcess` / `NtTerminateProcess`，或在 DLL 里记录"最后一次 Present 到进程退出之间的时间与线程"），再用 `run-bisect.ps1` 比较不同 hook 子集。这决定窗口能否再拉长。
2. 把工作配置固化进脚本默认值，避免每次手打 `-SkipIatModule mhypbase.dll`。
3. 整理 captures 目录：单轮游戏内截帧已占 1.17 GB，`.rdc` 不宜长期入库（见 `run-bisect.ps1` 与 `.gitignore` 的说明）。

已完成的工程事项：`E:\pfrenderdoc-captures` 已建为独立 git 仓库（分支 `main`，首次提交 `decb0d0`，136 个受控文件，仓库约 2 MB），`.gitignore` 排除 `*.dmp` 等大二进制；`run-bisect.ps1` 支持一次提权连跑多个配置。选择独立仓库而非并入 `E:\pfrenderdoc`，是因为后者是 RenderDoc 上游分支，不宜混入证据文件。

后续仍不要求客户端源码，不声称已有开发构建，也不将改变签名、重命名模块或修改保护组件作为已验证的修复办法。

## 官方参考

- [ProcDump](https://learn.microsoft.com/en-us/sysinternals/downloads/procdump)
- [WinDbg 安装](https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger)
- [CDB 命令行参数](https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/cdb-command-line-options)
- [用户态 dump 分析](https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/analyzing-a-user-mode-dump-file)
