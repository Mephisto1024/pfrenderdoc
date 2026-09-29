// Fixture for dynamic constant buffer indexing.
//
// The register index is computed at runtime, so the decompiler cannot name a struct member and has
// to declare the buffer as a flat float4 array and index into it. There is deliberately no loop or
// branch here: this isolates the constant-buffer change from the control-flow structuring fallback,
// which is a separate mechanism.

cbuffer Params : register(b0)
{
  float4 data[64];
};

float4 ps_dynamic_cbuffer(float2 uv : TEXCOORD0) : SV_Target
{
  uint index = (uint)(uv.x * 63.0) & 63u;

  float4 a = data[index];
  float4 b = data[(index + 7u) & 63u];

  // Read the same registers as integers. The buffer is declared as float4, so an integer load has
  // to reinterpret the bits rather than convert them.
  int bits = asint(data[(index + 3u) & 63u].w);
  uint shifted = (uint)bits >> 16;

  return a + b + float(shifted);
}
