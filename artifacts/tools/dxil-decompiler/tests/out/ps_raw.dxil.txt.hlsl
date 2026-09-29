float4 main(
  nointerpolation uint TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  ByteAddressBuffer _3 = ResourceDescriptorHeap[11u];
  int4 _4 = asint(_3.Load4((int)(TEXCOORD)));
  float _9 = asfloat(_4.x);
  float _10 = asfloat(_4.y);
  float _11 = asfloat(_4.z);
  float _12 = asfloat(_4.w);
  SV_Target.x = _9;
  SV_Target.y = _10;
  SV_Target.z = _11;
  SV_Target.w = _12;
  return SV_Target;
}
