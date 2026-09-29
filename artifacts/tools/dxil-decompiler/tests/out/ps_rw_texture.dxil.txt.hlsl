float4 main(
  nointerpolation uint2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  RWTexture2D<uint2> _4 = ResourceDescriptorHeap[7u];
  _4[int2(TEXCOORD.x, TEXCOORD.y)] = int2(TEXCOORD.x, TEXCOORD.y);
  float _5 = float((uint)(int)(TEXCOORD.x));
  float _6 = float((uint)(int)(TEXCOORD.y));
  SV_Target.x = _5;
  SV_Target.y = _6;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  return SV_Target;
}
