# RenderDoc 截帧改造 Progress

> 依据：《RenderDoc 截帧改造：终末地与鸣潮》离线文章  
> 建档日期：2026-08-30  
> 工作目录：`E:\pfrenderdoc`  
> 计划替换名：`rendertest` / `RenderTest`（与原文一致）

## 1. 当前状态

- 当前阶段：构建系统与六个输出名称已完成静态验收，等待改造版本构建
- 源码改造进度：约 30%（按已完成并验证的源码改造清单估算）
- 构建状态：原版 x64/Win32 Release 基线构建成功；尚未构建改造版本
- 功能验证：尚未开始
- 阻塞项：本机未安装 VS v140 工具集；原版基线已使用 VS 2022 v143 覆盖构建

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

## 3. 构建环境

- [x] 确认 Visual Studio 版本及 Windows SDK 版本。
- [ ] 安装或启用 VS2015 `v140` 平台工具集；若决定升级工具集，记录所有兼容性调整。
- [x] 确认 x64 与 Win32 两种配置均可生成。
- [ ] 记录最终采用的配置：`Release` / `Development`、x64 / Win32。

当前环境：Visual Studio Community 2022 17.14.32；已安装 Windows SDK 10.0.22621.0、10.0.26100.0；原版基线使用 `PlatformToolset=v143`、`WindowsTargetPlatformVersion=10.0.22621.0`。

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
- [ ] 确认最终输出为 `rendertestui.exe`，并检查生成的 Manifest。

## 6. Replay Marker

目标文件：`renderdoc/api/replay/renderdoc_replay.h`

- [ ] 将导出标记由 `renderdoc__replay__marker` 调整为 `rendertest__replay__marker`。
- [ ] 检查 DLL 端通过 `RDOC_BASE_NAME` 查找的符号名是否与导出端完全一致。
- [ ] 使用导出表工具确认 UI 程序包含新的 Replay Marker。

验证标准：核心 DLL 在 UI/replay 进程中能够正确识别 replay 环境，不会错误安装捕获 Hook 或导致 UI 崩溃。

## 7. 进程创建与注入路径

目标文件：`renderdoc/os/win32/win32_process.cpp`

- [ ] 将所有硬编码的 `renderdoccmd.exe` 路径同步为 `rendertestcmd.exe`。
- [ ] 将所有硬编码的 `renderdocshim32.dll`、`renderdocshim64.dll` 路径同步为新名称。
- [ ] 覆盖 Development、Release、Win32、x64 及安装目录等路径分支。
- [ ] 检查 `CREATE_SUSPENDED` 创建、注入和恢复流程未被命名修改破坏。

验证标准：x64 与跨位数辅助路径均能找到对应的新命名文件。

## 8. 自身进程注入排除

目标文件：`renderdoc/os/win32/sys_win32_hooks.cpp`

- [ ] 将自身进程判断中的 `renderdoccmd.exe` 更新为 `rendertestcmd.exe`。
- [ ] 将 UI 判断中的 `qrenderdoc.exe` 更新为 `qrendertest.exe`。
- [ ] 同时核对 `app` 与 `cmd` 两个判断分支。

验证标准：新命名的命令行工具和 UI 不会被当作普通目标再次注入。

## 9. 崩溃处理

目标文件：`renderdoc/core/crash_handler.h`、`renderdoccmd/renderdoccmd_win32.cpp`

- [ ] 统一修改命名事件，例如 `RENDERTEST_CRASHHANDLE`。
- [ ] 修改 Crash Handler 启动路径中的命令行程序名。
- [ ] 修改 Dump 目录为新的产品目录。
- [ ] 修改核心模块查找名称为 `rendertest.dll`。
- [ ] 检查创建端与监听端使用完全一致的事件名和通信参数。

验证标准：人工触发受控测试崩溃后，处理进程可以启动并生成 Dump。

## 10. 文件路径、配置与注册表

目标文件：`renderdoc/os/win32/win32_stringio.cpp`

- [ ] 修改 UI 可执行文件查找路径为 `qrendertest.exe`。
- [ ] 修改配置、临时文件或注册表使用的产品目录名。
- [ ] 搜索同类路径拼接逻辑，确认没有遗漏的原始硬编码名称。

验证标准：配置读写、日志、临时文件和 UI 启动均落到新命名路径。

## 11. Shim 与进程间共享对象

目标文件：`renderdocshim/renderdocshim.h` 及相关调用端

- [ ] 修改 `SHIM_DLL_NAME` 的 32 位与 64 位名称。
- [ ] 修改全局 Hook 共享内存名称，例如 `RenderTestGlobalHookData32/64`。
- [ ] 搜索命名管道、命名事件、共享内存等 IPC 标识符。
- [ ] 确保 IPC 的创建端和打开端同步修改。

验证标准：32 位和 64 位 Shim 均可读取正确的共享配置，且不存在双方名称不一致。

## 12. Qt UI 层

目标文件包括：

- `qrenderdoc/Code/qrenderdoc.cpp`
- `qrenderdoc/Windows/MainWindow.cpp`
- `qrenderdoc/renderdocui_stub.cpp`

任务：

- [ ] 修改 Qt 翻译上下文及应用描述中的产品名称。
- [ ] 修改主窗口标题中的显示名称。
- [ ] 将 Stub 查找的 UI 主程序更新为 `qrendertest.exe`。
- [ ] 检查 About、错误消息、日志和命令行帮助中的旧名称。

验证标准：`rendertestui.exe` 能找到并启动 `qrendertest.exe`，UI 正常显示且不崩溃。

## 13. 其他可识别标识

- [ ] `renderdoc/driver/gl/wgl_platform.cpp`：修改窗口类名 `renderdocGLclass`。
- [ ] `renderdoc/data/renderdoc.rc`：修改 `FileDescription`、`InternalName`、`OriginalFilename`、`ProductName`。
- [ ] `qrenderdoc/Code/pyrenderdoc/PythonContext.cpp`：修改 Python program name。
- [ ] 检查版本资源、图标资源、PDB 名称及安装包元数据。
- [ ] 全仓库搜索大小写不同的 `renderdoc`、`qrenderdoc`、`rdoc` 标识，并逐项判断是否需要修改。

注意：第三方版权声明、许可证、源码归属和用户文档中的必要署名不应为了改名而删除。

## 14. 输出文件核对

- [ ] 确认核心 DLL：`rendertest.dll`。
- [ ] 确认 UI Stub：`rendertestui.exe`。
- [ ] 确认 Qt UI：`qrendertest.exe`。
- [ ] 确认命令行工具：`rendertestcmd.exe`。
- [ ] 确认 Shim：`rendertestshim32.dll`、`rendertestshim64.dll`。
- [ ] 确认所有程序的导入表、模块查找和相对路径均引用新文件名。
- [ ] 确认构建目录中没有因旧产物残留而产生“误通过”。

建议在干净的独立输出目录中完成最终验证。

## 15. 构建与功能验证

- [ ] 完整清理后构建 x64 Release。
- [ ] 完整清理后构建 Win32 Release。
- [ ] UI Stub 启动测试。
- [ ] Qt UI 独立启动测试。
- [ ] Replay Marker 识别测试。
- [ ] 使用自有或明确授权的 D3D11 测试程序进行启动式截帧。
- [ ] 使用自有或明确授权的 D3D12 测试程序进行截帧。
- [ ] 如项目需要，补充 Vulkan/OpenGL 测试。
- [ ] 保存并重新打开 `.rdc` 文件，验证回放及资源查看。
- [ ] 验证跨位数辅助工具与 Shim。
- [ ] 验证 Crash Handler 和 Dump 输出。
- [ ] 记录失败日志、复现步骤和修复提交。

## 16. 最终一致性审计

- [ ] 在源码中搜索旧的可执行文件名和 DLL 名。
- [ ] 在最终二进制中检查与运行时协议有关的旧字符串。
- [ ] 检查导出表、版本资源和 Manifest。
- [ ] 检查所有命名事件、共享内存和管道的两端是否一致。
- [ ] 对照文章清单逐项复核，没有只改项目名而漏改实际输出名。
- [ ] 在全新目录部署输出文件并重复功能验证。
- [ ] 更新本文件的完成比例、构建信息和已知问题。

## 17. 构建记录模板

| 日期 | Commit | VS/工具集 | 平台/配置 | 结果 | 日志路径 | 备注 |
|---|---|---|---|---|---|---|
| 2026-08-30 | `97708677bcc3fdab6cdb3899d459870a591b8153` | VS 2022 17.14.32 / v143 / SDK 10.0.22621.0 | x64 / Release | 成功，0 Warning、0 Error | `build-logs/baseline-release-x64.log` | 原版基线；命令行覆盖项目声明的 v140 |
| 2026-08-30 | `97708677bcc3fdab6cdb3899d459870a591b8153` | VS 2022 17.14.32 / v143 / SDK 10.0.22621.0 | Win32 / Release | 成功，0 Warning、0 Error | `build-logs/baseline-release-x86.log` | 原版基线；命令行覆盖项目声明的 v140 |

## 18. 测试记录模板

| 日期 | 测试项 | 测试目标 | 结果 | 截帧/日志位置 | 备注 |
|---|---|---|---|---|---|
| — | UI 启动 | 本地构建产物 | 未开始 | — | — |
| — | D3D11 截帧 | 自有/授权测试程序 | 未开始 | — | — |
| — | D3D12 截帧 | 自有/授权测试程序 | 未开始 | — | — |
| — | `.rdc` 回放 | 本地测试截帧 | 未开始 | — | — |

## 19. 已知问题与决策

| 编号 | 状态 | 问题/决策 | 影响 | 处理方案 |
|---|---|---|---|---|
| 1 | 待决策 | 本机未安装 v140；是否正式采用 v143 工具集 | 影响项目兼容性和构建环境 | 原版基线已使用 v143 成功构建；改造版本构建前确认是否继续使用命令行覆盖或修改项目配置 |
| 2 | 待构建验证 | `qrendertest.exe` 输出名已在 VS、qmake 与 CMake 路径中统一 | 影响 Stub 启动和自身注入排除 | 静态检查已通过，等待改造版本构建及启动验证 |

## 20. 使用边界

本进度文档用于记录 RenderDoc 源码研究和经授权的图形调试测试。实际测试应限定在自有程序、离线样例或得到明确授权的目标上，并遵守相关软件许可、用户协议及适用规则。本文档不把“未被检测”作为功能验收标准；验收重点是改名后各组件之间仍能正确构建、启动、通信、截帧和回放。
