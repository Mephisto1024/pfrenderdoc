float4 main(
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  Texture2D<float4> _4 = ResourceDescriptorHeap[1u];
  SamplerState _6 = SamplerDescriptorHeap[2u];
  float4 _7 = _4.Sample(_6, float2(TEXCOORD.x, TEXCOORD.y));
  SV_Target.x = _7.x;
  SV_Target.y = _7.y;
  SV_Target.z = _7.z;
  SV_Target.w = _7.w;
  return SV_Target;
}
