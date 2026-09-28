# 把 etnlgd/HLSLDecompiler 接入 RenderDoc

## 结论：可行，这是 RenderDoc 的一等公民功能

RenderDoc 自带“自定义着色器处理工具”机制（实现见 `qrenderdoc/Code/Interface/ShaderProcessingTool.cpp`）。
从源码可以确认它给外部工具的契约：

- RenderDoc 把着色器字节码写到 `%TEMP%\shader_input`，**没有扩展名**，并把该路径替换进 `{input_file}`；
- 参数里**不含** `{output_file}` 时，RenderDoc 会把该进程的 **stdout** 重定向到 `%TEMP%\shader_output` 并读回来当作 HLSL 结果；
- **stderr** 单独写到 `%TEMP%\shader_stdout`，只显示在日志里，**不会混进着色器文本**；
- 工具跑完后 RenderDoc 删掉自己的临时文件，但会**故意保留** `shader_input`，方便你手动复现这次调用。

这也解释了为什么接这个工具只需要一个把 `.hlsl` 打到 stdout 的 wrapper。本目录已经做好并实测通过。

## 本目录内容

| 文件 | 说明 |
| --- | --- |
| `cmd_Decompiler.exe` | etnlgd/HLSLDecompiler 提供的 3Dmigoto 反编译器（`-D` 模式），633 KB |
| `decompile.bat` | RenderDoc 的 wrapper；**Executable 要指向这个文件**，不是 exe |
| `fixup.ps1` | 修复 3Dmigoto 输出里会让 RenderDoc 报致命错的 `uiDest` 缺陷（见下），由 wrapper 自动调用 |

目录可以整体移动或复制到任何位置，wrapper 用 `%~dp0` 定位 exe，移动后只要更新配置里的路径即可。

## 来源与许可

`cmd_Decompiler.exe` 来自 [etnlgd/HLSLDecompiler](https://github.com/etnlgd/HLSLDecompiler)（从 3Dmigoto 的 `cmd_Decompiler` 派生），本目录随附的是 commit `80aaaee96a217e54f0f56fc5d52d731857beac5a` 的 `x64\Release` 构建。

许可是 **MIT**（版权归 3Dmigoto project authors），条款见 `LICENSE-cmd_Decompiler.txt`，随二进制一并分发以满足 MIT 的“保留版权声明”要求。

`decompile.bat`、`fixup.ps1`、本 README 是为适配 RenderDoc 新写的，不属于上游。

## 安装方式一：GUI

`Tools → Settings → Shader Viewer` 标签页（列表列头是 `Tool` / `Process`）→ `Add`，填：

| 字段 | 值 |
| --- | --- |
| Name | `HLSLDecompiler` |
| Tool Type | `Custom Tool` |
| Executable | `D:\pfrenderdoc\artifacts\tools\hlsl-decompiler\decompile.bat` |
| Command Line | `{input_file}` |
| Input/Output | `DXBC` / `HLSL` |

## 安装方式二：直接改配置

先退出 RenderDoc，再编辑 `%APPDATA%\qrenderdoc\UI.config`，在 `ShaderProcessors` 数组里加一条：

```json
{
    "args": "{input_file}",
    "executable": "D:/pfrenderdoc/artifacts/tools/hlsl-decompiler/decompile.bat",
    "input": 1,
    "name": "HLSLDecompiler (3Dmigoto)",
    "output": 5,
    "tool": 0
}
```

字段含义（`input`/`output` 是 `ShaderEncoding` 的枚举值，JSON 里必须用正斜杠写路径）：

- `input: 1` = DXBC，`output: 5` = HLSL
- 完整枚举：`Unknown=0, DXBC=1, GLSL=2, SPIRV=3, SPIRVAsm=4, HLSL=5, DXIL=6, OpenGLSPIRV=7, OpenGLSPIRVAsm=8, Slang=9`
- `tool: 0` = `KnownShaderTool::Unknown`，即“自定义工具”（1~13 是内置工具的编号，别占用）

## 用法

在 Pipeline State 里选中任意着色器阶段 → 在着色器编辑器/反汇编视图上右键，会出现
**`Decompile with HLSLDecompiler`**（源码位置 `PipelineStateViewer.cpp`，菜单项文案是 `Decompile with %1`）。
点它之后，原本那个 `// HLSL function stub generated` 模板会被换成真正的反编译 HLSL，之后可以继续编辑再 Refresh。

## 为什么需要 fixup.ps1（重要）

RenderDoc 编译替换着色器时用的是 `D3DCOMPILE_WARNINGS_ARE_ERRORS`
（`renderdoc/driver/d3d11/d3d11_shader_cache.cpp`），所以警告会变成致命错误。
3Dmigoto 的输出在这一点上有个必踩的坑：对 DXBC 的 `resinfo` 指令，它生成

```hlsl
t2.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
r0.z = uiDest.w;          // .w 从未被写过
```

`GetDimensions` 的 mip 数量是从**第三个**输出参数返回的（前两个是宽高），所以 mip 数其实落在
`uiDest.z`，而下一行读的是 `uiDest.w`——读到的是未初始化值。在 RenderDoc 里点 Apply 会直接报：

```
error X4000: variable 'uiDest' used without having been completely initialized
```

这个缺陷对**任何**用到 `GetDimensions`/`resinfo` 的着色器都会出现，不是本捕获特有的。

`fixup.ps1` 把读的那一侧改写成 `GetDimensions` 真正写入的那个分量。它只在“文件里所有
`GetDimensions` 调用都指向同一个槽、且该槽不是 `.w`”时才动手，否则原样透传并在 stderr 上警告——
改动是安全的，不会误改已经自洽的输出。修复动作会在 RenderDoc 的日志里留一行说明。

## 已实测（按 RenderDoc 的真实调用方式）

| 用例 | 结果 |
| --- | --- |
| 无扩展名输入 + stdout 捕获（与 RenderDoc 完全一致） | 退出码 0；stdout 与反编译器生成的 `.hlsl` 逐字节一致（fixup 无改动时）；stderr 只有进度信息 |
| **用 RenderDoc 的参数编译 wrapper 的输出**（`fxc /T ps_5_0 /E main /WX`） | 退出码 0，编译通过 |
| 同一输入、绕过 fixup 直接编译反编译器的原始输出 | **退出码 1**，复现出 `(69,3-17): error X4000: variable 'uiDest' used without having been completely initialized`——与用户在 RenderDoc 里看到的一字不差 |
| 输入不是合法着色器（并预置了一份上次残留的 `.hlsl`） | 退出码 1，stdout **0 字节**（没把残留结果当成本次结果返回），stderr 报明确错误 |
| 不给参数 | 退出码 1，stderr 报错 |

测试用的输入就是本仓库的 `../../ssr-water-ps/pixel.dxbc`，输出与 `pixel_decompiled.hlsl` 同源。

## 注意点

1. **依赖 `d3dcompiler_47.dll`**（dumpbin 确认的导入项之一，另一个是 kernel32）。Win10/11 的 `System32` 自带，缺失时把 SDK 里 x64 那份（`C:\Program Files (x86)\Windows Kits\10\bin\<ver>\x64\d3dcompiler_47.dll`）复制到本目录即可。exe 静态链接了 CRT，不需要装 VC++ 运行库。
2. `%TEMP%\shader_input` 和 `shader_input.hlsl` 会一直残留（RenderDoc 故意不删输入）。要清理就手动删这两个文件。
3. wrapper 每次运行前会先删掉 `<输入名>.hlsl`，否则 RenderDoc 复用同一个临时文件名时，失败的那次会把上一次的 HLSL 当作结果返回——这是上游原始 wrapper 没有处理的一个坑。
4. wrapper 现在会调用 `fixup.ps1`（需要系统自带的 Windows PowerShell）。若脚本或 PowerShell 不可用，会退化为直接输出原始反编译结果，此时 `uiDest` 那类缺陷仍会导致 Apply 报 X4000。
5. 反编译结果是“长得像反汇编的 HLSL”，不是原始源码；但它能重新编译成 `ps_5_0`，所以适合在 RenderDoc 里改着色器做实验。
6. 如果 RenderDoc 无法直接启动 `.bat`，回退方案：Executable 填 `cmd.exe`，Command Line 填 `/c "D:\pfrenderdoc\artifacts\tools\hlsl-decompiler\decompile.bat" {input_file}`。
7. 该工具只处理 **DXBC**（D3D11 / SM5 及以下）。DXIL（SM6）或 Vulkan 捕获用不了它——那类要走别的路线。
8. 本目录的二进制是从 `%TEMP%\HLSLDecompiler-e9236\x64\Release\` 复制过来的，临时目录随时可能被系统清理，所以放到了这里。
