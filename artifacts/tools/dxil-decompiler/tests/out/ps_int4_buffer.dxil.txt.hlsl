int4 main(
  nointerpolation uint TEXCOORD : TEXCOORD
) : SV_Target {
  int4 SV_Target;
  Buffer<int4> _3 = ResourceDescriptorHeap[6u];
  int4 _4 = _3.Load(TEXCOORD);
  SV_Target.x = _4.x;
  SV_Target.y = _4.y;
  SV_Target.z = _4.z;
  SV_Target.w = _4.w;
  return SV_Target;
}
