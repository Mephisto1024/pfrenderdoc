# SSR 水面反射像素着色器反编译记录

着色器：Unity 内部名 `Hidden/Internal-SSR-Water` 的像素阶段（`ps_5_0`，入口 `main`，`ResourceId::63245`）。

来源捕获：`C:/Users/TA001/Pictures/rdc/yuanshen/ssr04.rdc`（D3D11）中的 EID 9236。
注意 **EID 是捕获内的事件序号**，换个捕获就对应不同事件，所以目录名不用它。

绑定：`t0`~`t4`、`s0`/`s1`、`b0`(224B)/`b1`(112B)/`b2`(336B)，输出 3 个 RT（`o0` 反射色×权重、`o1` 屏幕色、`o2.x` 标志）。

原始字节码：`pixel.dxbc`（7296 字节）。捕获内没有原始 HLSL，RenderDoc 的 Edit Shader 给出的是 stub 模板。

## 产物

| 文件 | 来源 | 状态 |
| --- | --- | --- |
| `pixel.dxbc` | 从捕获提取的原始 DXBC | 基准 |
| `pixel_decompiled.hlsl` | 路线 A：etnlgd/HLSLDecompiler（3Dmigoto 血统），DXBC→HLSL 直接反编译 | fxc `ps_5_0` 编译通过 |
| `pixel_yyadorigi.hlsl` | 路线 B：YYadorigi/HLSL-Decompiler 原始输出 | 编译通过，但输入语义有 off-by-one |
| `pixel_yyadorigi_patched.hlsl` | 路线 B 输出 + 修正输入语义 | fxc `ps_5_0` 编译通过 |
| `pixel_clean.hlsl` | **路线 A 的清理版，推荐直接用于 RenderDoc 替换** | 编译通过，指令流与清理前逐条一致 |
| `build/*.asm` | 上述各份经 fxc 重编译后的反汇编 | 供对比 |

`pixel_clean.hlsl` 相对路线 A 原始输出只做了四处改动：删掉 3Dmigoto 专用的 `IniParams`(t120)/`StereoParams`(t125) 声明；把 `#define cmp -` 改成自解释的 `#define cmp(x) (-(x))`（`cmp(x)` 即真为 -1、假为 0，与 3Dmigoto 约定一致）；把常量缓冲数组改为与 RenderDoc 常量缓冲查看器同名的 `cbN_vM` 成员；删掉两个未使用的临时变量。文件头写明了来源、改动与未验证项。

## 路线 B 的实际管线

该仓库是三个第三方二进制工具的包装器（见其 `main.cpp`），DXBC 模式下依次执行：

```
dxbc2dxil.exe   <in.dxbc> -o <tmp.dxil> -emit-bc
dxil-spirv.exe  <tmp.dxil> --output <tmp.spv> --raw-llvm
spirv-cross.exe <tmp.spv>  --output <out.hlsl> --hlsl --shader-model 50
```

即 DXBC → DXIL（dxilconv）→ SPIR-V（dxil-spirv）→ HLSL（SPIRV-Cross），共三次 IR 转换。
上游 README 称结果可还原“Unreal Engine 5 项目的原始 HLSL”；对 Unity 的 SM5 DXBC 而言，这是重建代码，不是原始源码。

工具链当前位于临时目录，可能被系统清理：

- `%TEMP%\HLSL-Decompiler-YY-e9236\`（已构建好的 `dxbc2dxil.exe` / `dxil-spirv.exe` / `spirv-cross.exe`，以及 `eid9236_ps.dxil`、`eid9236_ps.spv`）
- `%TEMP%\HLSLDecompiler-e9236\`（路线 A 的 3Dmigoto 血统源码与构建）

## 已验证

1. 全部 HLSL 变体都能用 fxc 按 `ps_5_0` 编译通过（`C:\Program Files (x86)\Windows Kits\10\bin\10.0.26100.0\x64\fxc.exe`）。
2. 路线 B 存在一个可复现缺陷：原始 PS 输入为 `SV_POSITION` + `TEXCOORD0..3`，而 YYadorigi 原始输出写成 `TEXCOORD1..4`，与捕获中 VS 的输出无法按语义绑定。`pixel_yyadorigi_patched.hlsl` 修正为 `TEXCOORD0..3` 后签名正确。路线 A 的输出签名与原始完全一致（含 `SV_POSITION` 与寄存器分布）。
3. 立即数与常量缓冲访问点在两条路线中与原始一致（`0.05 / 0.0625 / 0.15 / 6.666667 / 32 / 48 / -0.005`，`cb0`×12、`cb2`×12）。
4. 重编译字节码结构相似度（按操作码+操作数形态归一化后的多重集重合度，仅作启发式）：

   | 对比 | 相似度 |
   | --- | --- |
   | 原始 DXBC ↔ 路线 A 重编译 | 84.1% |
   | 原始 DXBC ↔ 路线 B 重编译（修正版） | 55.3% |
   | 路线 B 本次重编译 ↔ 上一轮重编译 | 100%（结果可复现） |

   路线 B 经过三次 IR 转换，SPIRV-Cross 会把表达式展开成 `movc`/`mad` 并对每个分量重复求值，因此字节码差异明显更大；这不等于语义错误，但可读性与贴近度不如路线 A。

5. `pixel_clean.hlsl` 的清理**不改变代码生成**：用同一 fxc 参数重编译后，与清理前的 294 条指令逐条比对零差异（`Compare-Object` 无输出），仅 RDEF 反射元数据因“数组改具名成员”而变化——这正是本次清理的目的。输入/输出签名与原始着色器逐字段一致。

6. 从 RDEF 反射可确认该着色器实际只用到这些常量槽（可用于对照 RenderDoc 常量缓冲查看器里的数值）：

   | 缓冲 | 实际使用的槽 |
   | --- | --- |
   | `cb0`（224B） | `v2`、`v8`、`v9`、`v10`、`v11`、`v12`、`v13` |
   | `cb1`（112B） | `v5`、`v6` |
   | `cb2`（336B） | `v9`、`v10`、`v11`、`v17`、`v18`、`v19`、`v20` |

   其中 `cb2_v17`~`v20` 按 `x/y/z` 加权再补偿 `w` 的用法与 4×4 矩阵一致（很可能是 `UNITY_MATRIX_VP`），`cb2_v9`~`v11` 是同一族的 3×3 部分；`cb0_v8.xy` 是屏幕尺寸（被转成 `uint2`），`cb1_v5.xyz` 是相机位置，`cb0_v2.z` 是一个用于分支的标志位。（语义为按指令推断，未经原工程源码确认。）

7. `GetDimensions` 的 mip 数量落在**第三个**输出参数上（前两个是宽高）。原始 DXBC 是 `resinfo_..._uint r0.z, l(0), t2.xywz`，即把 mip 数写进 `r0.z`；而 3Dmigoto 的原始输出写的是 `uiDest.z`、读的却是 `uiDest.w`，读到的是未初始化值。这在 RenderDoc 里是**致命错误**（见下方第 8 条），已修正为读写都用 `.z`。修正后 `resinfo` 指令与原始逐字符一致，且整条指令流与修正前零差异。

8. RenderDoc 在 `renderdoc/driver/d3d11/d3d11_shader_cache.cpp` 里用 `D3DCOMPILE_WARNINGS_ARE_ERRORS` 编译替换着色器，所以任何未初始化变量的警告都会变成报错，例如：

   ```
   error X4000: variable 'uiDest' used without having been completely initialized
   ```

   这条在本仓库用 `fxc /T ps_5_0 /E main /WX` 可以完整复现（行号列号都一致）。三个交付文件现在都能在 `/WX` 下编译通过。

## 尚未验证

- **两条路线都没有做像素级等价性验证**：没有在 GPU 上用捕获中的输入（纹理、常量缓冲）分别运行原着色与重建着色并比对输出。
- 分支/循环边界（48 次迭代上限）的处理是按指令语义推定的，未经运行确认。

## 用 `pixel_clean.hlsl` 做 RenderDoc 替换

1. 在 EID 9236 的 Pipeline State 里打开像素着色器的 Edit Shader（当前显示的是 stub 模板），把 `pixel_clean.hlsl` 的内容整体贴进去。
2. 编译参数用 `ps_5_0` / 入口 `main`；本仓库已用 `fxc /nologo /T ps_5_0 /E main` 验证通过。
3. 输入输出签名与原始一致，常量缓冲大小也对得上（224/112/336 字节），不需要手工调整绑定——`t0`~`t4`、`s0`/`s1`、`b0`~`b2` 都按原寄存器。
4. 若要改反射/调试，注意 `cmp(x)` 是宏，语义为 `x ? -1 : 0`。

注意事项：这是重建代码，不是原始 HLSL。直接 Apply 会改变回放画面的风险主要来自“重建语义与原语义存在未知偏差”，而不是签名不匹配；改动前建议先只做原样 Apply 看画面是否与未替换时一致。
