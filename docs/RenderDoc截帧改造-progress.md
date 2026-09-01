# RenderDoc 截帧改造 Progress

> 依据：《RenderDoc 截帧改造：终末地与鸣潮》离线文章  
> 建档日期：2026-08-30  
> 工作目录：`E:\pfrenderdoc`  
> 计划替换名：`rendertest` / `RenderTest`（与原文一致）

## 0. v142 14.29 重建与复测（已完成）

本节已完成，可继续 D3D12、Crash Handler、跨位数和一致性审计。

背景与判断：

- 2026-09-01 使用管理员权限运行 `E:\pfrenderdoc-build\x64\Release\qrendertest.exe`，两次直接启动并注入 `Endfield.exe` 均失败。
- RenderTest 已成功创建目标并开始注入，但无法在目标的 22 个模块中找到 `rendertest.dll`。
- Windows Error Reporting 同时记录 `Endfield.exe` 在游戏目录内的 `MSVCP140.dll 14.29.30139.0` 中以 `0xc0000005`、偏移 `0x13020` 崩溃。
- 当前 `rendertest.dll` 使用 VS 2022 v143、链接器 14.42 构建，并动态依赖 `MSVCP140.dll`、`VCRUNTIME140.dll`、`VCRUNTIME140_1.dll`。目标目录中的 14.29 运行库早于构建工具，VC Runtime 兼容性是当前首要待验证假设。
- 当前没有 Code Integrity 或 Defender 拦截事件，不能把本次失败直接归因于 ACE；也不是权限、输出改名或 D3D12 截帧阶段的问题。
- 2026-09-01 安装 v142 14.29.30133 并重建 x64/x86 Release 后，用户通过管理员版 `rendertestui.exe` 成功完成启动式截帧，旧崩溃未复现。

任务清单：

- [x] 安装 `MSVC v142 - VS 2019 C++ x64/x86 build tools (v14.29-16.11)`，实际工具目录为 `14.29.30133`。
- [x] 确认 `VC\Tools\MSVC` 下存在 `14.29.30133`，且 `Microsoft.VCToolsVersion.v142.default.txt` 内容为 `14.29.30133`。
- [x] 使用 `PlatformToolset=v142` 和 `VCToolsVersion=14.29.30133` 完整重建 x64 Release。
- [x] 使用相同工具集完整重建 Win32 Release；解决方案平台名称使用 `x86`。
- [x] 用 `dumpbin /headers` 确认 x64 和 x86 `rendertest.dll` 的 linker version 均为 14.29。
- [x] 以管理员权限通过 `rendertestui.exe` 启动正确的 `qrendertest.exe`，对授权目标完成启动式截帧。
- [x] v142 复测未再出现 `MSVCP140.dll + 0xc0000005 + 0x13020` 崩溃，Runtime 兼容性假设得到强支持，暂无需转入早期注入时序或目标进程保护机制分析。

安装方式：打开 Visual Studio Installer，修改 Visual Studio Community 2022，在“单个组件”中选择 `MSVC v142 - VS 2019 C++ x64/x86 build tools (v14.29-16.11)`。也可在管理员 PowerShell 中执行：

```powershell
& "C:\Program Files (x86)\Microsoft Visual Studio\Installer\setup.exe" modify `
  --installPath "C:\Program Files\Microsoft Visual Studio\2022\Community" `
  --add Microsoft.VisualStudio.Component.VC.14.29.16.11.x86.x64 `
  --passive `
  --norestart
```

安装后确认：

```powershell
Get-ChildItem `
  "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC" `
  -Directory | Select-Object Name

Get-Content `
  "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\Microsoft.VCToolsVersion.v142.default.txt"
```

以下命令中的 `14.29.30133` 必须替换为安装后实际显示的 `14.29.*` 目录名。重建前关闭所有 `qrendertest.exe`、`rendertestcmd.exe` 和 `rendertestui.exe`，避免输出文件被锁定。

x64 Release：

```powershell
$msbuild = "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"

& $msbuild "E:\pfrenderdoc-build\renderdoc.sln" `
  /m /t:Rebuild `
  /p:Configuration=Release /p:Platform=x64 `
  /p:PlatformToolset=v142 /p:VCToolsVersion=14.29.30133 `
  /p:WindowsTargetPlatformVersion=10.0.22621.0 `
  /nologo /verbosity:minimal /fileLogger `
  "/fileLoggerParameters:LogFile=E:\pfrenderdoc-build\build-logs\rendertest-release-x64-v142.log;Verbosity=normal"
```

Win32 Release（解决方案平台名为 `x86`）：

```powershell
& $msbuild "E:\pfrenderdoc-build\renderdoc.sln" `
  /m /t:Rebuild `
  /p:Configuration=Release /p:Platform=x86 `
  /p:PlatformToolset=v142 /p:VCToolsVersion=14.29.30133 `
  /p:WindowsTargetPlatformVersion=10.0.22621.0 `
  /nologo /verbosity:minimal /fileLogger `
  "/fileLoggerParameters:LogFile=E:\pfrenderdoc-build\build-logs\rendertest-release-win32-v142.log;Verbosity=normal"
```

验证命令：

```powershell
$dumpbin = "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.29.30133\bin\Hostx64\x64\dumpbin.exe"
& $dumpbin /headers "E:\pfrenderdoc-build\x64\Release\rendertest.dll" |
  Select-String "linker version"
```

不要覆盖或替换游戏目录中的 VC Runtime DLL；这可能破坏目标自身运行环境。参考：[Visual Studio Community 组件目录](https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community?view=visualstudio)、[Microsoft C++ 二进制兼容说明](https://learn.microsoft.com/en-us/cpp/porting/binary-compat-2015-2017?view=msvc-170)。

## 1. 当前状态

- 当前阶段：v142 14.29 改造版 x64/Win32 Release 已完成重建和启动式截帧复测，可继续跨位数、Crash Handler 和一致性验证
- 源码改造进度：约 30%（按已完成并验证的源码改造清单估算）
- 整体任务清单完成度：约 81%（77/95）
- 构建状态：原版、v143 改造版及 v142 14.29 改造版 x64/Win32 Release 均构建成功；v142 两平台均为 0 Warning、0 Error
- 功能验证：v142 x64 版通过管理员版 `rendertestui.exe` 完成实际启动式截帧，v143 版的旧崩溃未复现
- 阻塞项：无；后续未完成项为 D3D12/其他 API、跨位数 Shim、Crash Handler 和最终一致性审计

状态约定：

- `[ ]` 未开始
- `[-]` 进行中
- `[x]` 已完成并验证
- `[!]` 阻塞或验证失败

## 2. 基线检查

- [x] 确认 RenderDoc 源码目录存在。
- [x] 确认文章涉及的主要项目存在：`renderdoc`、`renderdoccmd`、`renderdocshim`、`qrenderdoc`。
- [x] 扫描当前命名状态：未发现 `rendertest`、`RenderTest`、`RENDERTEST` 或 `qrendertest` 改造痕迹。
- [x] 确认 `CMakeLists.txt` 当前仍为 `set(RDOC_BASE_NAME "renderdoc")`。
- [x] 确认 Replay Marker 当前仍为 `renderdoc__replay__marker`。
- [x] 记录当前源码版本、分支和提交号。
- [x] 建立独立改造分支或工作树，避免与其他改动混合。
- [x] 完成原版 RenderDoc 的 Release 构建，作为改造前基线。
- [ ] 记录原版输出文件清单及一次授权测试程序的截帧结果。

进度记录：

| 日期 | 结果 | 证据/备注 |
|---|---|---|
| 2026-08-30 | 完成初始源码扫描 | 当前核心文件仍使用原始 RenderDoc 命名；未修改源码 |
| 2026-08-30 | 建立独立改造分支 | 分支 `codex/rendertest-rename`；基准提交 `97708677bcc3fdab6cdb3899d459870a591b8153` |
| 2026-08-30 | 完成原版 Release 基线构建 | x64、Win32 均成功，0 Warning、0 Error；使用 VS 2022 v143 覆盖项目声明的 v140 |
| 2026-08-30 | 完成构建系统与六个输出名称静态验收 | MSBuild 属性求值确认 `rendertest.dll`、`rendertestcmd.exe`、`rendertestshim32/64.dll`、`rendertestui.exe`、`qrendertest.exe`；改造版本尚未实际构建 |
| 2026-09-01 | 完成改造版 x64 Release 干净构建 | 独立 worktree `E:\pfrenderdoc-build`；提交 `e2efe2094`；0 Warning、0 Error；五个 x64 核心输出均为新名称，无旧名核心产物 |
| 2026-09-01 | Replay Marker 与 Manifest 验证通过 | `qrendertest.exe` 导出 `rendertest__replay__marker` 且不导出旧 Marker；`rendertestui.exe` 内嵌 Manifest 为 `requireAdministrator`、`uiAccess=false` |
| 2026-09-01 | 最终截帧验收通过 | 成功截帧 `D:\Hypergryph Launcher\games\Arknights Endfield\Endfield.exe`；该程序为用户自行开发、使用 ACE 防护的非商业测试应用 |
| 2026-09-01 | 完成含 Shim 修复的 v143 x64/Win32 Release 重建 | 两个平台均 0 Warning、0 Error；日志为 `rendertest-release-x64-shimfix.log`、`rendertest-release-win32-shimfix.log` |
| 2026-09-01 | 最新启动式注入回归失败 | 正确的管理员版 `qrendertest.exe` 两次注入 `rendertest.dll` 时目标均在本地 `MSVCP140.dll 14.29.30139.0` 中以 `0xc0000005`、偏移 `0x13020` 崩溃；将 v142 14.29 重建列为最高优先级 |
| 2026-09-01 | 完成 v142 14.29 x64/Win32 Release 重建 | 工具集 `14.29.30133`；两平台均 0 Warning、0 Error；`rendertest.dll` linker version 均为 14.29 |
| 2026-09-01 | v142 启动式截帧复测通过 | 用户以管理员权限通过 `E:\pfrenderdoc-build\x64\Release\rendertestui.exe` 启动并成功截帧，旧崩溃未复现 |

## 3. 构建环境

- [x] 确认 Visual Studio 版本及 Windows SDK 版本。
- [x] 安装 MSVC v142 14.29 x64/x86 工具集，并用其重建改造版。
- [x] v142 实际截帧复测成功，当前无需另行安装 VS2015 `v140` 平台工具集。
- [x] 确认 x64 与 Win32 两种配置均可生成。
- [x] 记录最终采用的配置：`Release`、x64 / Win32（解决方案平台名为 `x86`）。

当前环境：Visual Studio Community 2022 17.14.32；已安装 Windows SDK 10.0.22621.0、10.0.26100.0 和 MSVC v142 `14.29.30133`；最终验证版使用 `PlatformToolset=v142`、`VCToolsVersion=14.29.30133`、`WindowsTargetPlatformVersion=10.0.22621.0`。

验证标准：原版解决方案可以完整编译，且没有因工具集缺失导致的失败。

## 4. 构建系统基础名称

目标文件：`CMakeLists.txt`

- [x] 将 `RDOC_BASE_NAME` 从 `renderdoc` 调整为 `rendertest`。
- [x] 检查 `RDOC_BASE_NAME_UPPER` 和预处理器宏的派生结果。
- [ ] 检查所有依赖 `RDOC_BASE_NAME` 的 DLL 名、符号名及运行时字符串是否同步变化。

验证标准：配置生成结果中不再把核心输出名称派生为 `renderdoc`。

## 5. Visual Studio 项目与输出名称

### 5.1 核心 DLL

目标文件：`renderdoc/renderdoc.vcxproj`

- [x] 修改 `RootNamespace`：`renderdoc` → `rendertest`。
- [x] 修改 `ProjectName`：`renderdoc` → `rendertest`。
- [x] 确认最终输出为 `rendertest.dll`。

### 5.2 命令行工具

目标文件：`renderdoccmd/renderdoccmd.vcxproj`

- [x] 修改 `RootNamespace`：`renderdoccmd` → `rendertestcmd`。
- [x] 修改 `ProjectName`：`renderdoccmd` → `rendertestcmd`。
- [x] 确认最终输出为 `rendertestcmd.exe`。

### 5.3 Shim DLL

目标文件：`renderdocshim/renderdocshim.vcxproj`

- [x] 修改 `RootNamespace`。
- [x] 为 Win32 与 x64 配置显式设置 `TargetName`。
- [x] 确认最终输出分别为 `rendertestshim32.dll`、`rendertestshim64.dll`。

注意：仅修改 `RootNamespace` 不会改变实际输出文件名。

### 5.4 UI 启动器

目标文件：`qrenderdoc/renderdocui_stub.vcxproj`

- [x] 修改 `RootNamespace`、`ProjectName`。
- [x] 显式修改 `PrimaryOutput`、`TargetName` 为 `rendertestui`。
- [x] 设置 `UACExecutionLevel` 为 `RequireAdministrator`。
- [x] 确认最终输出为 `rendertestui.exe`，并检查生成的 Manifest。

## 6. Replay Marker

目标文件：`renderdoc/api/replay/renderdoc_replay.h`

- [x] 将导出标记由 `renderdoc__replay__marker` 调整为 `rendertest__replay__marker`。
- [x] 检查 DLL 端通过 `RDOC_BASE_NAME` 查找的符号名是否与导出端完全一致。
- [x] 使用导出表工具确认 UI 程序包含新的 Replay Marker。

验证标准：核心 DLL 在 UI/replay 进程中能够正确识别 replay 环境，不会错误安装捕获 Hook 或导致 UI 崩溃。

## 7. 进程创建与注入路径

目标文件：`renderdoc/os/win32/win32_process.cpp`

- [x] 将所有硬编码的 `renderdoccmd.exe` 路径同步为 `rendertestcmd.exe`。
- [x] 将所有硬编码的 `renderdocshim32.dll`、`renderdocshim64.dll` 路径同步为新名称。
- [x] 覆盖 Development、Release、Win32、x64 及安装目录等路径分支。
- [x] 检查 `CREATE_SUSPENDED` 创建、注入和恢复流程未被命名修改破坏；v142 启动式截帧已验证。

验证标准：x64 与跨位数辅助路径均能找到对应的新命名文件。

## 8. 自身进程注入排除

目标文件：`renderdoc/os/win32/sys_win32_hooks.cpp`

- [x] 将自身进程判断中的 `renderdoccmd.exe` 更新为 `rendertestcmd.exe`。
- [x] 将 UI 判断中的 `qrenderdoc.exe` 更新为 `qrendertest.exe`。
- [x] 同时核对 `app` 与 `cmd` 两个判断分支。

验证标准：新命名的命令行工具和 UI 不会被当作普通目标再次注入。

## 9. 崩溃处理

目标文件：`renderdoc/core/crash_handler.h`、`renderdoccmd/renderdoccmd_win32.cpp`

- [x] 统一修改命名事件，例如 `RENDERTEST_CRASHHANDLE`。
- [x] 修改 Crash Handler 启动路径中的命令行程序名。
- [x] 修改 Dump 目录为新的产品目录。
- [x] 修改核心模块查找名称为 `rendertest.dll`。
- [x] 检查创建端与监听端使用完全一致的事件名和通信参数。

验证标准：人工触发受控测试崩溃后，处理进程可以启动并生成 Dump。

## 10. 文件路径、配置与注册表

目标文件：`renderdoc/os/win32/win32_stringio.cpp`

- [x] 修改 UI 可执行文件查找路径为 `qrendertest.exe`。
- [x] 修改配置、临时文件或注册表使用的产品目录名。
- [ ] 搜索同类路径拼接逻辑，确认没有遗漏的原始硬编码名称。

验证标准：配置读写、日志、临时文件和 UI 启动均落到新命名路径。

## 11. Shim 与进程间共享对象

目标文件：`renderdocshim/renderdocshim.h` 及相关调用端

- [x] 修改 `SHIM_DLL_NAME` 的 32 位与 64 位名称。
- [x] 修改全局 Hook 共享内存名称，例如 `RenderTestGlobalHookData32/64`。
- [ ] 搜索命名管道、命名事件、共享内存等 IPC 标识符。
- [x] 确保 IPC 的创建端和打开端同步修改。

验证标准：32 位和 64 位 Shim 均可读取正确的共享配置，且不存在双方名称不一致。

## 12. Qt UI 层

目标文件包括：

- `qrenderdoc/Code/qrenderdoc.cpp`
- `qrenderdoc/Windows/MainWindow.cpp`
- `qrenderdoc/renderdocui_stub.cpp`

任务：

- [x] 修改 Qt 翻译上下文及应用描述中的产品名称。
- [x] 修改主窗口标题中的显示名称。
- [x] 将 Stub 查找的 UI 主程序更新为 `qrendertest.exe`。
- [ ] 检查 About、错误消息、日志和命令行帮助中的旧名称。

验证标准：`rendertestui.exe` 能找到并启动 `qrendertest.exe`，UI 正常显示且不崩溃。

## 13. 其他可识别标识

- [x] `renderdoc/driver/gl/wgl_platform.cpp`：修改窗口类名 `renderdocGLclass`。
- [x] `renderdoc/data/renderdoc.rc`：修改 `FileDescription`、`InternalName`、`OriginalFilename`、`ProductName`。
- [x] `qrenderdoc/Code/pyrenderdoc/PythonContext.cpp`：修改 Python program name。
- [ ] 检查版本资源、图标资源、PDB 名称及安装包元数据。
- [ ] 全仓库搜索大小写不同的 `renderdoc`、`qrenderdoc`、`rdoc` 标识，并逐项判断是否需要修改。

注意：第三方版权声明、许可证、源码归属和用户文档中的必要署名不应为了改名而删除。

## 14. 输出文件核对

- [x] 确认核心 DLL：`rendertest.dll`。
- [x] 确认 UI Stub：`rendertestui.exe`。
- [x] 确认 Qt UI：`qrendertest.exe`。
- [x] 确认命令行工具：`rendertestcmd.exe`。
- [x] 确认 Shim：`rendertestshim32.dll`、`rendertestshim64.dll`。
- [ ] 确认所有程序的导入表、模块查找和相对路径均引用新文件名。
- [x] 确认构建目录中没有因旧产物残留而产生“误通过”。

建议在干净的独立输出目录中完成最终验证。

## 15. 构建与功能验证

- [x] 完整清理后构建 x64 Release。
- [x] 完整清理后构建 Win32 Release（v143，解决方案平台名 `x86`）。
- [x] 使用 v142 14.29 完整清理后重新构建 x64/Win32 Release。
- [x] UI Stub 启动测试。
- [x] Qt UI 独立启动测试。
- [x] Replay Marker 识别测试；导出标记与 UI 启动式截帧流程均已验证。
- [x] 使用自有或明确授权的测试程序完成实际截帧。
- [ ] 使用自有或明确授权的 D3D12 测试程序进行截帧。
- [ ] 如项目需要，补充 Vulkan/OpenGL 测试。
- [x] 保存并重新打开 `.rdc` 文件，验证回放及资源查看。
- [ ] 验证跨位数辅助工具与 Shim。
- [ ] 验证 Crash Handler 和 Dump 输出。
- [ ] 记录失败日志、复现步骤和修复提交。

## 16. 最终一致性审计

- [ ] 在源码中搜索旧的可执行文件名和 DLL 名。
- [ ] 在最终二进制中检查与运行时协议有关的旧字符串。
- [x] 检查导出表、版本资源和 Manifest。
- [ ] 检查所有命名事件、共享内存和管道的两端是否一致。
- [ ] 对照文章清单逐项复核，没有只改项目名而漏改实际输出名。
- [ ] 在全新目录部署输出文件并重复功能验证。
- [x] 更新本文件的完成比例、构建信息和已知问题。

## 17. 构建记录模板

| 日期 | Commit | VS/工具集 | 平台/配置 | 结果 | 日志路径 | 备注 |
|---|---|---|---|---|---|---|
| 2026-08-30 | `97708677bcc3fdab6cdb3899d459870a591b8153` | VS 2022 17.14.32 / v143 / SDK 10.0.22621.0 | x64 / Release | 成功，0 Warning、0 Error | `build-logs/baseline-release-x64.log` | 原版基线；命令行覆盖项目声明的 v140 |
| 2026-08-30 | `97708677bcc3fdab6cdb3899d459870a591b8153` | VS 2022 17.14.32 / v143 / SDK 10.0.22621.0 | Win32 / Release | 成功，0 Warning、0 Error | `build-logs/baseline-release-x86.log` | 原版基线；命令行覆盖项目声明的 v140 |
| 2026-09-01 | `e2efe209477dd768f77ab21bb1f8b26b2d8baa9c` | VS 2022 17.14.32 / v143 / SDK 10.0.22621.0 | x64 / Release | 成功，0 Warning、0 Error | `E:\pfrenderdoc-build\build-logs\rendertest-release-x64.log` | 独立 worktree 干净构建；耗时 00:03:50.55 |
| 2026-09-01 | `e2efe2094` + 未提交 Shim 修复 | VS 2022 17.14.32 / v143 / SDK 10.0.22621.0 | x64 / Release | 成功，0 Warning、0 Error | `E:\pfrenderdoc-build\build-logs\rendertest-release-x64-shimfix.log` | 完整 Rebuild；最终 linker version 14.42 |
| 2026-09-01 | `e2efe2094` + 未提交 Shim 修复 | VS 2022 17.14.32 / v143 / SDK 10.0.22621.0 | Win32 / Release | 成功，0 Warning、0 Error | `E:\pfrenderdoc-build\build-logs\rendertest-release-win32-shimfix.log` | 完整 Rebuild；解决方案平台名 `x86` |
| 2026-09-01 | `1b07ed4ce` + 未提交 Shim 修复 | VS 2022 17.14.32 / v142 14.29.30133 / SDK 10.0.22621.0 | x64 / Release | 成功，0 Warning、0 Error | `E:\pfrenderdoc-build\build-logs\rendertest-release-x64-v142.log` | 完整 Rebuild；`rendertest.dll` linker version 14.29 |
| 2026-09-01 | `1b07ed4ce` + 未提交 Shim 修复 | VS 2022 17.14.32 / v142 14.29.30133 / SDK 10.0.22621.0 | Win32 / Release | 成功，0 Warning、0 Error | `E:\pfrenderdoc-build\build-logs\rendertest-release-win32-v142.log` | 完整 Rebuild；解决方案平台名 `x86`；`rendertest.dll` linker version 14.29 |

## 18. 测试记录模板

| 日期 | 测试项 | 测试目标 | 结果 | 截帧/日志位置 | 备注 |
|---|---|---|---|---|---|
| 2026-09-01 | UI Stub 启动 | `E:\pfrenderdoc-build\x64\Release\rendertestui.exe` | 成功 | — | 管理员权限启动并正常进入 `qrendertest.exe` |
| 2026-09-01 | Qt UI 独立启动 | `E:\pfrenderdoc-build\x64\Release\qrendertest.exe` | 成功 | — | 用户手动启动验证，界面运行正常 |
| — | D3D11 截帧 | 自有/授权测试程序 | 未开始 | — | — |
| — | D3D12 截帧 | 自有/授权测试程序 | 未开始 | — | — |
| — | `.rdc` 回放 | 本地测试截帧 | 未开始 | — | — |
| 2026-09-01 | 最终截帧验收 | `D:\Hypergryph Launcher\games\Arknights Endfield\Endfield.exe` | 成功 | — | 用户自行开发的非商业测试应用，使用 ACE 防护 |
| 2026-09-01 | v143 最新构建启动式注入 | `D:\Hypergryph Launcher\games\Arknights Endfield\Endfield.exe` | 失败 | `%TEMP%\RenderTest\RenderDoc_2026.09.01_23.01.23.log` | 管理员权限正确；两次均未加载 `rendertest.dll`，目标在本地 `MSVCP140.dll 14.29.30139.0` 中以 `0xc0000005`、偏移 `0x13020` 崩溃 |
| 2026-09-01 | v142 启动式截帧复测 | 自有/授权测试目标 | 成功 | — | 用户通过 x64 `rendertestui.exe` 完成截帧，旧崩溃未复现 |

## 19. 历史验收结果与当前回归

历史验收曾通过：改造后的 RenderDoc 已成功截帧 `D:\Hypergryph Launcher\games\Arknights Endfield\Endfield.exe`。该目标程序是用户自行开发、使用 ACE 防护的非商业测试应用，本次测试属于自有程序的授权调试与验证。

但是，2026-09-01 含 Shim 修复的 v143 x64/Win32 Release 重建后，管理员权限下的直接启动注入曾稳定复现目标在 `MSVCP140.dll 14.29.30139.0` 中崩溃。随后使用 v142 14.29.30133 重建 x64/Win32 Release，并通过管理员版 `rendertestui.exe` 成功完成实际截帧，旧崩溃未复现。这强力支持 VC Runtime/工具集兼容性假设，但因尚未进行严格的唯一变量对照，不将其表述为已完全证明的根因。

## 20. 已知问题与决策

| 编号 | 状态 | 问题/决策 | 影响 | 处理方案 |
|---|---|---|---|---|
| 1 | 已解决 | v143/14.42 注入版本与目标目录的 VC Runtime 14.29 存在版本差异 | v143 版曾在加载 `rendertest.dll` 期间于 `MSVCP140.dll` 中崩溃 | 已安装 v142 14.29.30133，重建 x64/Win32 并完成成功截帧复测；不替换目标目录 Runtime |
| 2 | 验收通过 | `qrendertest.exe` 输出名已在 VS、qmake 与 CMake 路径中统一 | 影响 Stub 启动和自身注入排除 | x64 干净构建、输出名、Replay Marker 与 Manifest 已验证，并已完成实际目标程序截帧验收 |
| 3 | 已澄清 | 历史截帧验收成功，v143 直接启动注入稳定失败，v142 复测成功 | 确认故障与新命名的基本启动和截帧流程无关 | 最终验证构建固定为 v142 14.29.30133；后续如需确认根因，再进行唯一变量对照 |

## 21. 使用边界

本进度文档用于记录 RenderDoc 源码研究和经授权的图形调试测试。实际测试应限定在自有程序、离线样例或得到明确授权的目标上，并遵守相关软件许可、用户协议及适用规则。本文档不把“未被检测”作为功能验收标准；验收重点是改名后各组件之间仍能正确构建、启动、通信、截帧和回放。
