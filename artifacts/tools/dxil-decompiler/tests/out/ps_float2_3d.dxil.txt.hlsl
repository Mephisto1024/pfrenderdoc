float4 main(
  linear float3 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  Texture3D<float2> _5 = ResourceDescriptorHeap[3u];
  SamplerState _7 = SamplerDescriptorHeap[4u];
  float2 _8 = _5.SampleLevel(_7, float3(TEXCOORD.x, TEXCOORD.y, TEXCOORD.z), 0.0f);
  SV_Target.x = _8.x;
  SV_Target.y = _8.y;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  return SV_Target;
}
