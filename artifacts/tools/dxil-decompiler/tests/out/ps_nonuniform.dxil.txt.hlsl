float4 main(
  linear float2 TEXCOORD : TEXCOORD,
  nointerpolation uint INDEX : INDEX
) : SV_Target {
  float4 SV_Target;
  Texture2D<float4> _5 = ResourceDescriptorHeap[NonUniformResourceIndex((int)(INDEX))];
  SamplerState _7 = SamplerDescriptorHeap[10u];
  float4 _8 = _5.Sample(_7, float2(TEXCOORD.x, TEXCOORD.y));
  SV_Target.x = _8.x;
  SV_Target.y = _8.y;
  SV_Target.z = _8.z;
  SV_Target.w = _8.w;
  return SV_Target;
}
