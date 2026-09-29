cbuffer Params : register(b0) {
  float4 Params[64] : packoffset(c0);
};

float4 main(
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _4 = TEXCOORD.x * 63.0f;
  uint _5 = uint(_4);
  int _6 = _5 & 63;
  uint _12 = _5 + 7u;
  int _13 = _12 & 63;
  uint _19 = _5 + 3u;
  int _20 = _19 & 63;
  int _23 = asint((Params[_20].w));
  int _24 = (uint)(_23) >> 16;
  float _25 = (Params[_13].x) + (Params[_6].x);
  float _26 = (Params[_13].y) + (Params[_6].y);
  float _27 = (Params[_13].z) + (Params[_6].z);
  float _28 = (Params[_13].w) + (Params[_6].w);
  float _29 = float((uint)_24);
  float _30 = _25 + _29;
  float _31 = _26 + _29;
  float _32 = _27 + _29;
  float _33 = _28 + _29;
  SV_Target.x = _30;
  SV_Target.y = _31;
  SV_Target.z = _32;
  SV_Target.w = _33;
  return SV_Target;
}
