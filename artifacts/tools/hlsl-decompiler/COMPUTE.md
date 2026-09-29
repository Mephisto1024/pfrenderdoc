# DXBC compute shader support

The existing RenderDoc shader processor entry still points to `decompile.bat` with `{input_file}`. The wrapper now reads the DXBC shader kind. For compute shaders it runs `compute-decompile.ps1`; for other shader stages it keeps the existing 3Dmigoto path and `fixup.ps1`.

The compute route uses the bundled `compute-bin` programs to translate DXBC → DXIL → SPIR-V → HLSL. It restores 4-byte scalar structured UAV declarations when SPIRV-Cross emits a typed `RWBuffer`, then checks the output with `fxc /T cs_5_0 /E main /WX` and confirms those UAV declarations survive recompilation. `fxc.exe` from the Windows SDK must be available on `PATH` or in `Windows Kits\10\bin\*\x64`.

The binaries were copied from a local build of the toolchain described by [YYadorigi/HLSL-Decompiler](https://github.com/YYadorigi/HLSL-Decompiler): Microsoft `dxbc2dxil`/`dxilconv`, `dxil-spirv`, and `SPIRV-Cross`. Their license files are in `compute-bin`. This path reconstructs HLSL and is not guaranteed to recover the original source. Compute shaders with structured UAVs wider than 4 bytes currently fail with a clear error rather than returning a shader with mismatched bindings.

Verification: with EID 5405's original DXBC passed through `decompile.bat` using the same extensionless input and stdout capture as RenderDoc, the output compiled under `cs_5_0 /WX`. Replacing the shader in an independent replay produced byte-identical data for all six mip levels that EID 5405 writes; see `../../eid5405/compare_tool_replay.log`. A pixel shader from `../../ssr-water-ps/pixel.dxbc` still compiles after passing through the legacy path.
