# Endfield 抓帧失败排查

日期：2026-10-10（Asia/Shanghai）。目标：`D:\Hypergryph Launcher\games\Arknights Endfield\Endfield.exe`。

清理后保留：已验证的 `elevated-v142-correct-layer/Endfield_frame1920.rdc` 及其预览图、`E:\pfrenderdoc\x64\Endfield-v142` 兼容工具、此记录、启动脚本，以及集中在 `logs` 的关键日志。源码副本、编译中间文件、测试程序和其余四份帧已移入回收站，约 9.09 GiB，可恢复；尚未清空回收站。游戏和兼容版界面已退出，Vulkan 注册于 2026-10-10 01:02:29 自动恢复。

## 当前构建复现

- `E:\pfrenderdoc\x64\Release\rendertest.dll`：Linker 14.42，修改时间 2026-10-02 12:19:08。
- 普通权限：Windows error 740，目标要求管理员权限。证据：`logs/launch-unelevated.log`。
- 管理员权限：PID 57888，注入时未能在 21 个模块中找到 `rendertest.dll`，target control ID 0。证据：`logs/launch-v143.log`。
- 同一 PID 的 Windows 事件：2026-10-10 00:41:54，游戏目录内 `MSVCP140.dll 14.29.30139.0`，`0xc0000005`，偏移 `0x13020`。证据：`logs/windows-crash-events.txt`。
- 注入失败后游戏曾继续启动，后续退出。因此不能把进程存在或游戏窗口出现当成注入/抓帧成功。
- 此次未生成 `.rdc`，失败发生在 DLL 加载阶段。

## 独立运行库对照

实验使用同一 `mutex-runtime-probe.cpp`，每个实验目录都放置从游戏目录复制的 `msvcp140.dll`、`vcruntime140.dll` 和 `vcruntime140_1.dll`。未修改游戏文件或系统运行库。测试程序及实验目录已在清理时移入回收站，下表保留验证结果。

| 编译工具集 | 设置 | 结果 |
| --- | --- | --- |
| 14.42.34433 | 默认 `/MD` | PID 40648，第一次 `std::mutex::lock()` 崩溃，退出码 -1073741819（0xc0000005），Windows 事件也是 MSVCP140.dll + 0x13020 |
| 14.29.30133 | 默认 `/MD` | PID 59684，lock/unlock 成功，退出码 0 |
| 14.42.34433 | `/D_DISABLE_CONSTEXPR_MUTEX_CONSTRUCTOR` | lock/unlock 成功，退出码 0 |

上述对照直接证明新 STL mutex 构造方式和该旧运行库不兼容，并复现游戏崩溃的完整模块/异常/偏移签名。尚未取得游戏自身的崩溃调用栈，不能据此声称已经定位到游戏进程中的某个具体 C++ 调用者。

系统 `C:\Windows\System32\msvcp140.dll` 是 14.51.36247.0，但 Windows 事件显示游戏实际使用自己的 14.29 文件；仅更新系统 Redistributable 不能保证改变实际加载版本。

微软 STL 17.10 发布说明明确记载：新 mutex 构造实现配合旧 Redistributable 可能发生空指针访问，可以用 `_DISABLE_CONSTEXPR_MUTEX_CONSTRUCTOR` 作为兼容措施。

来源：https://github.com/microsoft/STL/releases/tag/vs-2022-17.10

## 后续验证

曾在 `E:\pfrenderdoc\artifacts\endfield-v142-source` 创建源文件副本，使用 `/p:PlatformToolset=v142 /p:VCToolsVersion=14.29.30133 /p:WindowsTargetPlatformVersion=10.0.22621.0` 完整构建 Release x64。原源码和 `x64\Release` 产物均未覆盖。该临时副本和中间产物已移入回收站。

构建日志：`logs/build-v142.log`，构建成功，0 warnings / 0 errors，耗时 4 分 23.86 秒。可用兼容程序已复制到 `E:\pfrenderdoc\x64\Endfield-v142`。

### 第一次 v142 游戏验证

- PID 36560，DLL 初始化、RegisterHooks、启动式注入均成功，target control ID 38920。
- 30 秒自动 TriggerCapture 已调用，但没有生成 `.rdc`。
- 游戏采用 Vulkan。HKLM 原有的 `E:\pfrenderdoc\x64\Release\rendertest.json` 仍指向 14.42 DLL；还有一份 `C:\Program Files\RenderDoc\renderdoc.json`（1.46）。
- 游戏启动约 8–36 秒后，Windows 事件再次记录同一 PID 的 MSVCP140.dll + 0x13020，最终 60 秒退出，退出码 0xdeadc0de。证据：`logs/launch-v142-old-layer.log`。注入成功与 Vulkan 真正加载的层不是同一件事。

### 第二次 v142 游戏验证

管理员抓帧脚本 `run-capture-elevated.ps1 -UseCompatibleVulkanLayer` 临时禁用旧 RenderTest 层登记，登记兼容目录的 manifest；原注册值现保存在 `logs/vulkan-registration-before.xml`，恢复时间保存在 `logs/vulkan-registration-restored.txt`。脚本 finally 在游戏退出后恢复。单次进程环境 `DISABLE_VULKAN_RENDERDOC_CAPTURE_1_46=1` 防止官方 1.46 层与 RenderTest 同时启用。

验证成功：PID 38320，Vulkan 设备、绘制和 Present 已被接管，实际进入角色与场景的游戏画面。此轮到 90 秒后仍正常运行，没有复现 MSVCP140.dll + 0x13020。

排查时生成 5 份 `.rdc`，清理后仅保留第 1920 帧；其余四份已移入回收站：

| 帧号 | 大小（字节） |
| --- | --- |
| 633 | 230573038 |
| 1452 | 1624409862 |
| 1635 | 1646046454 |
| 1920 | 1588209026 |
| 3201 | 1662316809 |

推荐分析文件：`elevated-v142-correct-layer/Endfield_frame1920.rdc`，约 1.48 GiB。`thumb` 抽取成功；缩略图包含游戏角色、场景和 HUD；`rendertestcmd.exe replay --loops 1` 实际回放成功，退出码 0。新兼容 GUI 也已打开此帧，状态栏明确显示 `Endfield_frame1920.rdc loaded. No problems detected.`。证据：`logs/launch-v142-correct-layer.log`、该帧同目录的 `Endfield_frame1920.png`、`logs/replay-1920.stdout.txt`、`logs/replay-1920-exit-code.txt`。

原 `x64\Release` 和游戏目录未被修改。该轮游戏和 helper 均已退出，原 Vulkan 登记已自动恢复。只打开兼容 GUI 并不能保证下一次启动使用兼容 Vulkan 层；需要同时使用匹配的层登记和避免双 RenderDoc 层启用。

下一次复现可在管理员 PowerShell 中运行（RunName 每次更换以保留证据）：

```powershell
& 'E:\pfrenderdoc\artifacts\endfield-diagnosis-20261010-004059\run-capture-elevated.ps1' -ToolDir 'E:\pfrenderdoc\x64\Endfield-v142' -RunName ('capture-' + (Get-Date -Format 'yyyyMMdd-HHmmss')) -UseCompatibleVulkanLayer
```

## 结论

本次证据支持两个具体原因：当前 14.42 DLL 与游戏私有 14.29 MSVC runtime 不兼容，以及仅换注入 DLL 后 Vulkan 层登记仍指向旧 DLL。管理员权限是启动前提。v142 重建加上正确的单一 Vulkan 捕获层后，完整游戏帧已经写入并可回放。本次不需要进一步把失败归因于反作弊或修改游戏二进制。
