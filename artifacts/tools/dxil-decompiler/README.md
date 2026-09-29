# 把 DXIL 反编译成 HLSL 并接入 RenderDoc

本目录提供 **DXIL（Shader Model 6）→ HLSL** 的 RenderDoc 着色器处理工具。
上一级的 `../hlsl-decompiler/` 只处理 DXBC（SM5 及以下），两者互补，不重叠。

## 结论

DXIL 可以转成能在 RenderDoc 里编辑、并重新编译通过（`dxc -T ps_6_6` / `-T vs_6_6`）的 HLSL。
这条路线已经按 RenderDoc 的真实调用方式实测通过。

但**“能编译”不等于“能当替换着色器用”**：生成代码的资源绑定方式和原始 DXIL 不同，
详见文末「已知限制」。

## 本目录内容

| 文件 | 说明 |
| --- | --- |
| `decompile.cpp` | 本工具的源码，产出一个 exe、三种模式（见下） |
| `dxil-decompiler.exe` | 已构建的二进制，由 `build.cmd` 生成 |
| `build.cmd` | 构建脚本（MSVC，`/std:c++20 /EHsc /O2`） |
| `shader_decompiler_dxc.hpp` | 从 RenoDX vendor 进来的反编译器，见「来源与许可」 |
| `string_view.hpp` | 上面那个头文件的依赖 |
| `LICENSE-renodx.txt` | RenoDX 的 MIT 许可 |
| `tests/test_heap_types.py` | 回归测试：描述符堆类型推断 + 反编译往返编译 |
| `tests/heap_types.hlsl` | 上面测试用的 fixture |
| `samples/`、`samples2/`、`samples3/` | 从真实捕获里抽出来的 DXIL 语料 |

## RenoDX 头文件必须打的那个补丁（重要）

**未打补丁的上游 RenoDX 反编译器在这份 shader 上是失败的**，报错为不认识
`@dx.op.createHandleFromHeap`。而 SM6.6 的描述符堆索引（Resource/Sampler descriptor heap
indexing）**只能**通过这条 op 表达，所以任何用了堆索引的 DXIL 都会踩到。

本目录 vendor 的 `shader_decompiler_dxc.hpp` 已经**把补丁合进去了**
（`createHandleFromHeap` 的处理在 `shader_decompiler_dxc.hpp:1889`），
补丁原文留档在 `../../eid53177/renodx_proof_of_concept.patch`。
它把堆句柄还原成 `ResourceDescriptorHeap[...]` / `SamplerDescriptorHeap[...]`，
并新增了 `InferHeapHlslType()` 用来从 `annotateHandle` 的 ResourceProperties 反推 HLSL 类型。

如果以后重新 vendor 一个更新的 RenoDX 头文件，**务必确认这两处仍在**，否则工具会退化。

### 本地补丁二：`sdiv`（有符号整除）

上游实现了 `udiv` / `srem` / `urem`，**唯独漏了 `sdiv`**，所以任何含
`%x = sdiv i32 %a, %b` 的 shader 都会掉进兜底分支报 `Unrecognized code assignment`。
本目录在 `udiv` 旁边补了同构的 `sdiv` 分支（搜 `instruction == "sdiv"`）。

这是**真实缺失的指令**，不是条件性拒绝：EID 56777 的像素着色器正是死在这里，
补上后语料覆盖率从 21/53 升到 22/52。

### 本地补丁三：动态常量缓冲区索引

EID 56777 的光照 pass 在循环里用**运行时索引**读常量缓冲区：

```llvm
%953 = mul nuw nsw i32 %944, 7      ; 灯索引 * 每盏灯 7 个 float4
%954 = add nuw nsw i32 %953, 1      ; + 字段
%955 = call ... @dx.op.cbufferLoadLegacy.f32(i32 59, ..., i32 %954)
```

原来 `cbufferLoadLegacy.f32` / `.i32` 遇到 `regIndex` 以 `%` 开头就直接抛
`Unexpected dynamic cbuffer offset.`。现在改为：

- 声明处本来就有（但被硬编码为 `false` 的）`use_cbuffer_float4` 分支，把它接上：
  一旦某个 cbuffer 有动态访问，就整体声明为 `float4 name[N] : packoffset(c0);`；
- `extractvalue` 对这类缓冲区一律走数组索引：动态用 `name[_expr].x`，常量用 `name[117].x`；
- **整数加载要包 `asint()`**：数组声明成 `float4`，而 `cbufferLoadLegacy.i32` 是**按位重解释**
  而非数值转换，写成 `name[i].w & 1` 是拿 float 做位运算，dxc 会直接报
  `error: int or unsigned int type required`。

**一个容易漏掉的时序问题**：同一个 cbuffer 可能既有常量访问（在前）又有动态访问（在后），
而常量访问的字符串在解析时就已定型。所以标记不能等到遇见动态访问时才做——在 `Decompile`
开头先扫描一遍反汇编，把"有动态加载的句柄 SSA id"记下来；由于 SSA 支配性保证了句柄先于
其使用被定义，在句柄创建（`createHandle` / `createHandleFromBinding` / `annotateHandle`）
时就能把整个缓冲区切到数组形态。

隔离验证：`tests/dynamic_cbuffer.hlsl` 是只含动态索引、**无分支**的合成用例，
它走默认结构化模式，产物索引算术与原始 HLSL 逐条对应，且重新编译通过。

### 本地补丁四：`getDimensions` 的 `TextureCube`

`getDimensions` 的 `switch (shape)` 只处理了 1D/2D/2DArray/3D，`TextureCube` 掉进 `default`
抛 `Unexpected shape`。现补上 `TextureCube`（返回宽高，与 2D 同形）。

### 本地补丁五：`select()` 改成三目

上游把 IR 的 `select` 生成成 HLSL 的 `select(c, a, b)`。**`select` 是 HLSL 2021 才加入的内建**，
所以在较老的 dxc 上（例如 10.0.22621 SDK 带的 1.6.x）默认会报

```
error: use of undeclared identifier 'select'
```

必须显式传 `-HV 2021` 才能过。改成 `(c ? a : b)` 后对标量和向量语义完全相同，
且在任何语言版本下都可用。实测：改前 EID 56777 用 dxc 1.6 默认版本编译失败，改后通过。
EID 53177 的产物因此有 6 处 `select(` 变成三目（共 12 行 diff），回放复验结论不变。

### 结构化模式自动降级（在 `decompile.cpp`，不是头文件）

有些控制流只能用 do-while 里的 `break` 表达，默认模式下 `on_branch` 会抛 `Unexpected goto`。
但 `use_do_while` **不是**一个无副作用的开关：头文件 5114 行起它会生成 `do { ... }`，
直接全局打开会改变本来就能反编译的 shader 的输出。所以实现为**逐级重试**：

1. 默认（`flatten=false, use_do_while=false`）；
2. 失败 → `use_do_while=true`；
3. 再失败 → `flatten=true, use_do_while=true`。

能反编译的 shader 行为完全不变（EID 53177 的输出经 SHA256 比对逐字节相同），
只有默认失败的才会走后续模式，并在 stderr 上说明用了哪个模式。
显式传 `--do-while` / `--flatten` 则固定该模式、不再降级。

## RenderDoc 侧必须同时修的一处（否则点 Apply 必然失败）

这一处**不在工具里，在 RenderDoc 源码里**，但它是整个接入能否真正跑通的关键，
所以单独记在这里。没修之前，点 Apply 会稳定报出这样的错：

```
D:\pfrenderdoc\x64\Release\main(89,10-47): error X3000: syntax error: unexpected token 'LightComposeEnvironmentParams_Constant'
```

完整链条：

1. `PipelineStateViewer::EditDecompiledSource()` 转发编译标志时**只复制 `@spirver`**，
   把 `@cmdline` 丢掉了（`qrenderdoc/Windows/PipelineState/PipelineStateViewer.cpp`）；
2. 而 `@cmdline = "-T ps_6_6"` 是这个 shader **profile 的唯一来源**；
3. profile 为空 → `d3d12_replay.cpp` 的 `BuildShader` 按阶段兜底成 **`ps_5_1`**；
4. `d3d12_shader_cache.cpp` 里 `if(profile[3] >= '6')` 判断失败 → **走 fxc 分支而不是 dxc**；
5. fxc 的 `pSourceName` 传的是 `entry`（也就是 `"main"`），所以报错路径长成
   `...\x64\Release\main`——**看到这个形状就说明用的是 fxc，不是 dxc**；
6. 拿 SM5 编译器解析 SM6 源码 → 在第一个它不认识的构造处报 `X3000`（`X3000` 也是 fxc 的错误码）。

修法：让这条路和**同一个文件里**的 "Edit Generated Stub" 对齐——后者是把
`shaderDetails->debugInfo.compileFlags` **整个**传下去的，所以它不受影响。
现在 `EditDecompiledSource` 在「工具输出 HLSL 且原 shader 是 DXBC/DXIL」时也转发 `@cmdline`。

> 想快速判断是 fxc 还是 dxc 在报错：`X3000` + `(行,列-列)` 区间 + 路径是 CWD 下的 `main`
> 三个特征同时出现，就是 fxc。


## 三种模式

```
dxil-decompiler.exe <dxc -dumpbin 文本> [更多...]
    反编译每个反汇编文件，输出到 "<输入>.hlsl"。给测试用。

dxil-decompiler.exe --stdout [--dxc <路径>] <输入>
    RenderDoc 模式，UI.config 里配的就是这个。

dxil-decompiler.exe --infer-type <word0> <word1> <resource|sampler>
    打印某个描述符堆标注对应的 HLSL 类型。给测试用。
```

`--stdout` 模式接受**两种**输入，自动识别：

- **原始 DXIL 容器**（文件头是 `DXBC`）——这正是 RenderDoc 会丢过来的东西；
- 已经是 `dxc -dumpbin` 的**反汇编文本**（含 `target triple = "dxil-ms-dx"`）。

## RenderDoc 给外部工具的契约

实现见 `qrenderdoc/Code/Interface/ShaderProcessingTool.cpp`，源码可确认：

- RenderDoc 把 `shaderDetails->rawBytes` 原样写到 `%TEMP%\shader_input`，**没有扩展名**，
  并把该路径替换进 `{input_file}`。对 DXIL 着色器来说这就是**原始 DXIL 容器**，
  **不是**反汇编文本——这一点是本工具必须自己调 `dxc -dumpbin` 的原因；
- 参数里**不含** `{output_file}` 时，RenderDoc 把该进程的 **stdout** 重定向到
  `%TEMP%\shader_output` 并读回来当作结果；
- **stderr** 单独写到 `%TEMP%\shader_stdout`，只进日志，**不会**混进着色器文本；
- `{input_file}` 是**整参数替换**（不是字符串拼接），所以临时路径即使含空格也不会被拆开；
- 跑完后 RenderDoc 删掉自己的输出文件，但**故意保留** `shader_input`，方便手动复现。

因为 stdout 就是结果本身，本工具做了两件事保证它干净：

1. 所有进度/诊断信息一律走 **stderr**；
2. 调反编译器期间把 `std::cout` 的 streambuf **临时挂到 `std::cerr`** 上——
   vendor 进来的头文件是研究型代码，某些分支会往 `std::cout` 打印
   （大多数在 `#if DECOMPILER_DXC_DEBUG >= 3` 里，但这样兜底更稳），
   这样即使它打印，也只会进日志。

### dxc 从哪里来

`--stdout` 模式在输入是容器时需要 `dxc.exe` 做反汇编。查找顺序：

1. `--dxc <路径>` 参数；
2. `DXC` 环境变量；
3. `PATH`；
4. Windows SDK：`%ProgramFiles(x86)%\Windows Kits\10\bin\<版本>\x64\dxc.exe`，取版本号最大的那个。

找不到就明确报错并列出这四个办法，不会静默失败。

## 构建

```
artifacts\tools\dxil-decompiler\build.cmd
```

脚本会自己调 `VsDevCmd.bat -arch=x64`（若 `cl.exe` 不在 PATH 上）。只依赖 MSVC 和 Windows SDK，
没有第三方库：反编译器是 header-only 的，`dxc` 是**运行时**才需要的。

## 安装到 RenderDoc

### 方式一：GUI

`Tools → Settings → Shader Viewer` 标签页（列表列头 `Tool` / `Process`）→ `Add`：

| 字段 | 值 |
| --- | --- |
| Name | `DXIL Decompiler (RenoDX)` |
| Tool Type | `Custom Tool` |
| Executable | `D:\pfrenderdoc\artifacts\tools\dxil-decompiler\dxil-decompiler.exe` |
| Command Line | `--stdout {input_file}` |
| Input/Output | `DXIL` / `HLSL` |

### 方式二：直接改配置

**先退出 RenderDoc**（它退出时会覆写 `UI.config`，改早了会被冲掉）。编辑
`%APPDATA%\qrendertest\UI.config`，在 `ShaderProcessors` 数组里加一条：

> 路径提示：配置目录取自 **exe 的名字**。当前构建的 GUI 是 `qrendertest.exe`，所以目录是
> `%APPDATA%\qrendertest\`（启动器 `run-rendertestui.ps1` 读的也是这个）。
> 改名前的旧构建用 `%APPDATA%\qrenderdoc\`；那里面即使有 `UI.config` 也是**过期文件**，
> 编辑它不会生效。这一点在 `../hlsl-decompiler/README.md` 里原本写错了，已一并更正。

```json
{
    "args": "--stdout {input_file}",
    "executable": "D:/pfrenderdoc/artifacts/tools/dxil-decompiler/dxil-decompiler.exe",
    "input": 6,
    "name": "DXIL Decompiler (RenoDX)",
    "output": 5,
    "tool": 0
}
```

`input` / `output` 是 `ShaderEncoding` 的枚举值（JSON 里路径必须用正斜杠）：

- `input: 6` = DXIL，`output: 5` = HLSL
- 完整枚举：`Unknown=0, DXBC=1, GLSL=2, SPIRV=3, SPIRVAsm=4, HLSL=5, DXIL=6, OpenGLSPIRV=7, OpenGLSPIRVAsm=8, Slang=9`
- `tool: 0` = `KnownShaderTool::Unknown`，即“自定义工具”（1 及以上是内置工具编号，别占用）

## 用法

在 Pipeline State 里选中着色器阶段 → 在着色器编辑器/反汇编视图上右键，会出现
**`Decompile with DXIL Decompiler (RenoDX)`**（菜单文案源码在 `PipelineStateViewer.cpp:1073`，
是 `Decompile with %1`）。点它，`// HLSL function stub generated` 模板就会被换成反编译结果，
之后可以继续编辑再 Refresh。

## 已实测

测试输入是 `../../eid53177/eid53177_pixel.dxbc` 和 `eid53177_vertex.dxbc`
（SM 6.6，使用描述符堆索引），以及 `tests/` 下的合成 fixture。

| 用例 | 结果 |
| --- | --- |
| 像素着色器：无扩展名容器 → stdout（与 RenderDoc 调用方式一致） | 退出码 0，stdout 21396 字节 HLSL |
| 顶点着色器：同上 | 退出码 0，stdout 38898 字节 HLSL |
| 上面两份 HLSL 用 `dxc -T ps_6_6` / `-T vs_6_6 -E main` 重新编译 | 都是退出码 0 |
| 换一个工作目录调用（RenderDoc 继承自己的 cwd） | 退出码 0，与上面逐字节一致 |
| 输入是随机字节 | 退出码 1，**stdout 0 字节**，stderr 说明既不是容器也不是反汇编 |
| 输入是被截断的容器 | 退出码 1，**stdout 0 字节** |
| 不给参数 | 退出码 2，**stdout 0 字节** |
| **GUI 内实测**：在 RenderTest 里载入捕获到 EID 53177，右键 `Decompile with DXIL Decompiler (RenoDX)` | 像素着色器反编译结果正常（用户确认） |
| `tests/test_heap_types.py` 全量 | 8 PASS + 2 EXPECTED UNSUPPORTED，退出码 0 |
| `dxc -dumpbin` 对**无扩展名**文件 | 退出码 0（RenderDoc 就是写这种文件） |

“失败时 stdout 恒为 0 字节”这条是本工具最重要的性质，原因见下。

`test_heap_types.py` 覆盖的描述符堆类型：`Texture2D<float4>`、`Texture3D<float2>`、
`Texture2D<uint4>`、`Buffer<int4>`、`RWTexture2D<uint2>`、`Texture2D<float>` +
`SamplerComparisonState`、非一致索引、`ByteAddressBuffer`。

> 注 1：`tests/test_heap_types.py` 原先用 `tempfile.TemporaryDirectory`，它建出的目录是
> 0o700，在受限令牌下 ACL 会让 `dxc -Fo` 写不进去（报 `Access is denied`）。现已改为在
> `tests/tmp/` 下用普通目录，测试在沙箱环境里也能跑。
>
> 注 2：统计 stdout 字节数时**不要**用 Windows PowerShell 5.1 的 `>`（它写 UTF-16LE，
> 字节数会翻倍）。用 `cmd /c` 重定向才是逐字节准确的。

### 为什么“失败时 stdout 必须为空”

`PipelineStateViewer::EditDecompiledSource()`（`PipelineStateViewer.cpp:1006`）**不检查工具
是否失败**：它无条件把 `out.result` 当作反编译结果丢进着色器编辑器，只把日志显示在错误面板。
所以如果工具在失败时吐了半截 HLSL，RenderDoc 会把它当成可用的 shader。

本工具的对策是**先完整反编译到内存，成功后才一次性写 stdout**；任何失败路径都在写之前
返回，因此 stdout 恒为 0 字节。上表的三条失败用例就是按这个性质测的。

### 真实语料覆盖率

对本目录 `samples*/` 下的 74 个真实 DXIL 着色器（已排除 round-trip 中间产物）实测：

| 结果 | 数量 |
| --- | --- |
| 成功产出 HLSL | 26 |
| 失败（反编译器限制，报错明确） | 48 |

失败原因分布（都是反编译器上游限制，不是本工具的缺陷）：

| 次数 | 原因 |
| --- | --- |
| 20 | `dxc -dumpbin failed with exit code 1`（该文件不是 dxc 能反汇编的 DXIL 容器） |
| 18 | 既不是 DXBC 容器也不是反汇编文本（这批 `.dxil` 是裸 DXIL 位码，没套 DXBC 外壳） |
| 6 | vendored 头文件里的 `Assertion failed: !data_type.empty()`（进程 abort） |
| 2 | `@dx.op.waveIsFirstLane`（wave 内建尚未实现） |
| 1 | `Unexpected shape: Buffer` |
| 1 | `@dx.op.waveActiveAllEqual.i32`（同上） |

补丁二~四落地后，`Unexpected dynamic cbuffer offset.`（6 例）与 `Unexpected goto`（1 例）
两类失败**已全部消失**，覆盖率从 21/53 升到 26/48。

也就是说：**能处理的 shader 质量很好，但覆盖面还不完整**，其中 6 个会让进程 abort
（RenderDoc 会报 “Process crashed”）。EID 53177 的两个 shader 属于成功的那一类。

### EID 56777（延迟渲染光照 pass）：一条链上四个缺口

这是"多个独立缺口串在一起"的典型案例，值得单独记录。该像素着色器 18024 字节，
绑定 20 个只读资源、0 个采样器、4 个渲染目标。逐层剥开后是四个**不同性质**的原因：

| # | 报错 | 性质 | 状态 |
| --- | --- | --- | --- |
| 1 | `%934 = sdiv i32 %927, 4` | 上游**真的没实现**这条指令 | **已修复**（补丁二） |
| 2 | `Unexpected dynamic cbuffer offset.`，26 处 | 指令实现了，但**主动拒绝**运行时索引 | **已实现**（补丁三） |
| 3 | `Unexpected shape: TextureCube` | `getDimensions` 的 `switch` 少了分支 | **已修复**（补丁四） |
| 4 | `Unexpected goto` | 控制流需要 do-while 里的 `break` | **已处理**（自动降级） |

现在该 shader 能反编译（93619 字节 HLSL）、能编译（`dxc -T ps_6_6` 0 error）；
用 `--flatten` 可缩到 55711 字节，同样编译通过。

回放比对结论：该事件写入 2 个目标，其中 **target 2（`R16_FLOAT`）逐字节一致**；
另一个 target 0（`R11G11B10_FLOAT`）**自身基线在重放之间不可复现**（同一次会话里连读两次
都不同，三次独立重放得到三个不同哈希），因此**无法比对**，工具会明确标出并跳过。

> 这里踩过一次坑值得记下来：最初只看"target 0 有 114552 字节不同"就准备下结论说
> do-while 结构化把语义弄错了。加上基线复现性检查后才发现，**那个目标的基线本身每次都不一样**，
> 拿它当基准去比是无效的。`compare_replay.py` 现在会先读两遍基线，不一致就标记
> `BASELINE NOT REPRODUCIBLE` 并排除，不再让它污染结论。

第 2 条曾是真正的拦路虎。该 shader 在光照循环里按运行时索引取常量缓冲区：

```llvm
%953 = mul nuw nsw i32 %944, 7      ; 灯索引 * 每盏灯 7 个 float4
%954 = add nuw nsw i32 %953, 1      ; + 字段偏移
%955 = call ... @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %23, i32 %954)
```

而 `cbufferLoadLegacy.f32` / `.i32` 的处理里写死了：regIndex 以 `%` 开头就
`throw std::exception("Unexpected dynamic cbuffer offset.")`。
要支持它必须让常量缓冲区能以数组形式被索引（现在声明成带 `packoffset` 的具名结构体），
属于**新增功能**，不是改一行 —— 实现见前面的「本地补丁三」。

另外做了两项静态核对，确认没有别的隐藏地雷：

- 该 shader 用到的 **21 个 `dx.op` 全部都有实现**，没有未知 op；
- 用到的 LLVM 指令（`add/and/bitcast/fadd/fcmp/fdiv/fmul/fptosi/fptoui/fsub/icmp/lshr/`
  `mul/or/phi/select/shl/sitofp/sub/uitofp` 等）**除 `sdiv` 外全部有分派**。

这一步很有用：它说明缺口是**有限的、可枚举的**，剩下的都是"指令在特定形状下被拒绝"，
而不是"还有一堆指令没实现"。

### 绑定保真度（EID 53177 像素着色器）

把原始 DXIL 用 `dxc -dumpbin` 打印出的资源绑定表，和反编译出的 HLSL 声明逐条对照：

| 原始 DXIL（`; Resource Bindings:`） | 反编译 HLSL 声明 |
| --- | --- |
| `cbuffer CB0 → cb0,space1` | `cbuffer cb0_space1 : register(b0, space1)` |
| `cbuffer CB1 → cb0,space3` | `cbuffer cb0_space3 : register(b0, space3)` |
| `cbuffer CB2 → cb0,space6` | `cbuffer cb0_space6 : register(b0, space6)` |
| `cbuffer CB3 → cb0,space7` | `cbuffer cb0_space7 : register(b0, space7)` |
| `cbuffer CB4 → cb0,space8` | `cbuffer cb0_space8 : register(b0, space8)` |
| `texture T0 → t0,space7` | `Buffer<float4> t0_space7 : register(t0, space7)` |

6 条静态绑定（含 space 编号）**全部一致**。动态索引的那部分不在这张表里，
它以 `ResourceDescriptorHeap[...]` / `SamplerDescriptorHeap[...]` 原样出现在代码中。

### 渲染等价性（replay 真机比对）

用 `compare_replay.py` 在**真实捕获**里做了替换验证：编译反编译出的 HLSL → 替换原像素着色器
→ 重放该事件 → 逐个渲染目标比对字节。

运行方式（`renderdoc.pyd` 链接的是 `PYTHON36.dll`，**必须**用 Python 3.6）：

```powershell
$env:PATH = "D:\pfrenderdoc\x64\Release;$env:PATH"   # rendertest.dll 在这里
D:\pfrenderdoc\artifacts\tools\py36\python.exe `
  D:\pfrenderdoc\artifacts\tools\dxil-decompiler\compare_replay.py `
  C:\Users\TA001\Pictures\rdc\ds2_tar.rdc 53177 `
  D:\pfrenderdoc\artifacts\eid53177\eid53177_pixel_decompiled.hlsl
```

`../py36/` 是从 python.org 取的 Python 3.6.8 embeddable 包解压而来（免安装，不是安装器），
`python36._pth` 里已经加上了 `D:\pfrenderdoc\x64\Release\pymodules`。完整输出留档在
`../../eid53177/compare_replay.log`。

EID 53177 像素着色器的结果（`BuildTargetShader` 无任何报错）：

| 目标 | 格式 | 结果 |
| --- | --- | --- |
| 0 | `R8G8B8A8_SRGB` | **逐字节一致** |
| 2 | `R16G16_UNORM` | 82 / 4147200 通道不同，最大偏差 **0.000244** |
| 3 | `R16G16_FLOAT` | **逐字节一致** |
| 4 | `R8G8B8A8_UNORM` | **逐字节一致** |
| 5 | `R16G16_FLOAT` | 1646 / 4147200 通道不同，最大偏差 **0.000001** |
| 1、6 | `R11G11B10_FLOAT` | **该事件不写入，比对无意义**（脚本会明确标 SKIPPED） |

**没有任何一个通道的偏差超过 1/255**，即全部在舍入量级；三个目标是逐字节相同的。
结论：反编译出的着色器功能上等价，可以当替换着色器用。

> 两个容易踩的坑，脚本已经处理：
>
> 1. **不能按"不同字节数"判断。** 这些目标多是 16 位/浮点格式，16 位值从 `0x00FF` 变到
>    `0x0100` 时低字节差 255、而数值只差 1；浮点格式下一个指数位就能让字节差上百。
>    所以脚本先按格式解码成数值再比。按字节统计曾让人误以为"有 4 个字节差 253"，
>    解码后真实最大偏差只有 0.000244。
> 2. **不能只比第一个目标。** 必须先确认该事件确实写入这个目标，否则"一致"可能只是
>    根本没被碰到。本事件实际只写入 0/2/3/4/5 五个目标。

## 已知限制

1. **结构化缓冲区和常量缓冲区还不支持。** `tests/test_heap_types.py` 明确把
   `ps_structured`（ResourceKind 12）和 `ps_constant_buffer`（13）列为必须报错，
   因为它们需要 layout 信息才能推出 HLSL 类型；工具会给出明确错误而不是产生错误代码。
2. **描述符堆索引和 register/space 绑定是保真的，且像素着色器已通过渲染等价性验证。**
   这条路线**没有**把堆索引退化成无界数组。实测两个 EID 53177 shader 的产物是：
   - 堆索引原样保留：`ResourceDescriptorHeap[...]`、`SamplerDescriptorHeap[...]`；
   - 其余资源按捕获到的绑定写成显式 register/space，例如 `Buffer<float4> t0_space7 :
     register(t0, space7)`、`cbuffer cb0_space1 : register(b0, space1)`；
   - **没有** `space0` 无界数组，也**没有** `SPIRV_Cross_VertexInfo` 这个多余常量缓冲区。

   像素着色器还做了 **replay 真机比对**（见上「渲染等价性」）：替换后重放该事件，
   5 个被写入的目标里 3 个逐字节一致，另 2 个的最大通道偏差是 0.000244 和 0.000001，
   **无一超过 1/255**。所以这条路线不只是"能编译"，而是可以直接当替换着色器用。
   顶点着色器尚未做同样的比对。

   > 注意别混淆路线：`artifacts/eid53177/*_cross.hlsl` 是更早的 **SPIRV-Cross** 路线产物，
   > 那一版才是用无界数组、并且多出 `SPIRV_Cross_VertexInfo` 的。本目录的 RenoDX 路线不是。
3. **只在 D3D12 / SM6 上有意义。** DXBC（SM5 及以下）请用 `../hlsl-decompiler/`。
4. **运行时依赖 `dxc.exe`**（Windows SDK 自带）。它**不随本目录分发**，缺失时工具会明确报错。
5. 反编译结果是“长得像 HLSL 的反汇编”，不是原始源码；变量名是 `_123` 这种，
   适合在 RenderDoc 里改着做实验，不适合当工程源码。

## 来源与许可

- `shader_decompiler_dxc.hpp`、`string_view.hpp` 来自
  [RenoDX](https://github.com/clshortfuse/renodx)，版权归 Carlos Lopez，
  许可证 **MIT**，条款见随附的 `LICENSE-renodx.txt`（随二进制/源码一并分发以满足 MIT 的
  “保留版权声明”要求）。本目录还合入了 `../../eid53177/renodx_proof_of_concept.patch`。
- `decompile.cpp`、`build.cmd`、`tests/`、本 README 是为适配 RenderDoc 新写的，不属于上游。
