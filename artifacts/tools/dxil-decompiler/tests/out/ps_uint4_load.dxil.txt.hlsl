uint4 main(
  nointerpolation uint2 TEXCOORD : TEXCOORD
) : SV_Target {
  uint4 SV_Target;
  Texture2D<uint4> _4 = ResourceDescriptorHeap[5u];
  uint4 _5 = _4.Load(int3(TEXCOORD.x, TEXCOORD.y, 0));
  SV_Target.x = _5.x;
  SV_Target.y = _5.y;
  SV_Target.z = _5.z;
  SV_Target.w = _5.w;
  return SV_Target;
}
