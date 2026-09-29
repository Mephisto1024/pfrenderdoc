# EID 5405 计算着色器的 HLSL

捕获：`C:\Users\TA001\Pictures\rdc\yuanshen\ssr04.rdc`，D3D11，`cs_5_0`。捕获中的计算着色器原始字节码与本目录的 `compute.dxbc` 逐字节一致（SHA-256：`c7ba167c181c1eff277383aff5efc79501f370cabd0ad4f66e2e26567cd6381e`）。

**可用于 RenderDoc Edit Shader 的文件：`compute.hlsl`**。入口是 `main`，目标是 `cs_5_0`。用 Windows SDK `fxc /T cs_5_0 /E main /WX` 编译成功，也通过 RenderDoc 的 `BuildTargetShader` 编译。

现已将计算着色器路径接入 `../tools/hlsl-decompiler/decompile.bat`。RenderDoc 原有的工具配置无需改动。通过该工具直接生成的 `compute_from_tool.hlsl` 也已编译，并在回放中得到相同的六个 mip；记录见 `compare_tool_replay.log`。

## 原报错原因

`compute_3dmigoto_unfixed.hlsl` 是当前 3Dmigoto 工具对该 DXBC 的原始输出。它生成了 `void main()`，但函数体引用了没有声明的 `vThreadIDInGroupFlattened`，所以第 49 行报 X3004。该值对应 HLSL 的 `SV_GroupIndex`；原 DXBC 的线程组声明是 `dcl_thread_group 256, 1, 1`，对应 `[numthreads(256, 1, 1)]`。

这个文件还有其他未转换的计算着色器指令，例如 `store_uav_typed`、`ld_structured`、组共享内存和原子操作。单独补入口参数之后，`fxc` 会在 `store_uav_typed` 报 X3000。因此此事件不能靠修补一个标识符来完成转换。

## 重建方法

使用 DXBC → DXIL → SPIR-V → HLSL 工具链重建源码，得到 `compute_cross.hlsl`。其中 `U1` 被声明为 `RWBuffer<uint>`，但原始 DXBC 是 `dcl_uav_structured u1, 4`。`compute.hlsl` 将其改为 `RWStructuredBuffer<uint>`，重编译后再次确认声明为 `dcl_uav_structured u1, 4`。其余资源槽与原始字节码一致，线程组仍为 256×1×1。

转换链所用工具来自 [YYadorigi/HLSL-Decompiler](https://github.com/YYadorigi/HLSL-Decompiler) 使用的 `dxbc2dxil`、`dxil-spirv` 和 `SPIRV-Cross`。中间产物 `compute.dxil`、`compute.spv` 和转换结果均保存在本目录。它们是重建代码，不是原始 HLSL。

## 验证

`compare_compute.py` 在独立 RenderDoc 回放中执行了原始着色器和重建着色器。脚本先确认 EID 5405 实际改写了同一张纹理的 mip 0–5，然后替换计算着色器并逐字节比较；六个 mip 全部一致。绑定的 4 字节缓冲区也一致，但该事件没有改写它，所以不能据此验证缓冲区写入路径。详细记录见 `compare_replay.log`。此结果只验证本捕获在 EID 5405 的输入与执行分支。
