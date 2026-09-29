float4 main(
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  Texture2D<float> _4 = ResourceDescriptorHeap[8u];
  SamplerComparisonState _6 = SamplerDescriptorHeap[9u];
  float _7 = _4.SampleCmpLevelZero(_6, float2(TEXCOORD.x, TEXCOORD.y), 0.5f);
  SV_Target.x = _7.x;
  SV_Target.y = _7.x;
  SV_Target.z = _7.x;
  SV_Target.w = _7.x;
  return SV_Target;
}
