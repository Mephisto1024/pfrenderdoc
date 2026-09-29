Texture2D<float4> g_DepthTexture : register(t1);

cbuffer cbCopyShadowMapDepth : register(b6) {
  float4 g_DynamicShadowToWorldMatrix[4] : packoffset(c000.x);
  float4 g_WorldToDynamicShadowMatrix[4] : packoffset(c004.x);
  float4 g_StaticShadowToWorldMatrix[4] : packoffset(c008.x);
  float4 g_WorldToStaticShadowMatrix[4] : packoffset(c012.x);
};

SamplerState SS_ClampPoint : register(s7);

float main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Depth {
  float SV_Depth;
  float _26 = (g_DynamicShadowToWorldMatrix[0].x) * TEXCOORD.x;
  float _27 = mad(TEXCOORD.y, (g_DynamicShadowToWorldMatrix[0].y), _26);
  float _28 = (g_DynamicShadowToWorldMatrix[0].w) + (g_DynamicShadowToWorldMatrix[0].z);
  float _29 = _28 + _27;
  float _30 = (g_DynamicShadowToWorldMatrix[1].x) * TEXCOORD.x;
  float _31 = mad(TEXCOORD.y, (g_DynamicShadowToWorldMatrix[1].y), _30);
  float _32 = (g_DynamicShadowToWorldMatrix[1].w) + (g_DynamicShadowToWorldMatrix[1].z);
  float _33 = _32 + _31;
  float _34 = (g_DynamicShadowToWorldMatrix[2].x) * TEXCOORD.x;
  float _35 = mad(TEXCOORD.y, (g_DynamicShadowToWorldMatrix[2].y), _34);
  float _36 = (g_DynamicShadowToWorldMatrix[2].w) + (g_DynamicShadowToWorldMatrix[2].z);
  float _37 = _36 + _35;
  float _38 = (g_DynamicShadowToWorldMatrix[3].x) * TEXCOORD.x;
  float _39 = mad(TEXCOORD.y, (g_DynamicShadowToWorldMatrix[3].y), _38);
  float _40 = (g_DynamicShadowToWorldMatrix[3].w) + (g_DynamicShadowToWorldMatrix[3].z);
  float _41 = _40 + _39;
  float _57 = (g_WorldToStaticShadowMatrix[0].x) * _29;
  float _58 = mad(_33, (g_WorldToStaticShadowMatrix[0].y), _57);
  float _59 = mad(_37, (g_WorldToStaticShadowMatrix[0].z), _58);
  float _60 = mad(_41, (g_WorldToStaticShadowMatrix[0].w), _59);
  float _61 = (g_WorldToStaticShadowMatrix[1].x) * _29;
  float _62 = mad(_33, (g_WorldToStaticShadowMatrix[1].y), _61);
  float _63 = mad(_37, (g_WorldToStaticShadowMatrix[1].z), _62);
  float _64 = mad(_41, (g_WorldToStaticShadowMatrix[1].w), _63);
  float _65 = (g_WorldToStaticShadowMatrix[3].x) * _29;
  float _66 = mad(_33, (g_WorldToStaticShadowMatrix[3].y), _65);
  float _67 = mad(_37, (g_WorldToStaticShadowMatrix[3].z), _66);
  float _68 = mad(_41, (g_WorldToStaticShadowMatrix[3].w), _67);
  float _69 = _60 / _68;
  float _70 = _64 / _68;
  bool _71 = (_69 >= 0.0f);
  bool _72 = (_70 >= 0.0f);
  bool _73 = _71 && _72;
  bool _74 = (_69 <= 1.0f);
  bool _75 = _74 && _73;
  bool _76 = (_70 <= 1.0f);
  bool _77 = _76 && _75;
  float _140;
  if (_77) {
    float4 _79 = g_DepthTexture.Sample(SS_ClampPoint, float2(_69, _70));
    bool _81 = !(_79.x <= 0.0f);
    if (_81) {
      float _103 = (g_StaticShadowToWorldMatrix[0].x) * _69;
      float _104 = mad(_70, (g_StaticShadowToWorldMatrix[0].y), _103);
      float _105 = mad(_79.x, (g_StaticShadowToWorldMatrix[0].z), _104);
      float _106 = _105 + (g_StaticShadowToWorldMatrix[0].w);
      float _107 = (g_StaticShadowToWorldMatrix[1].x) * _69;
      float _108 = mad(_70, (g_StaticShadowToWorldMatrix[1].y), _107);
      float _109 = mad(_79.x, (g_StaticShadowToWorldMatrix[1].z), _108);
      float _110 = _109 + (g_StaticShadowToWorldMatrix[1].w);
      float _111 = (g_StaticShadowToWorldMatrix[2].x) * _69;
      float _112 = mad(_70, (g_StaticShadowToWorldMatrix[2].y), _111);
      float _113 = mad(_79.x, (g_StaticShadowToWorldMatrix[2].z), _112);
      float _114 = _113 + (g_StaticShadowToWorldMatrix[2].w);
      float _115 = (g_StaticShadowToWorldMatrix[3].x) * _69;
      float _116 = mad(_70, (g_StaticShadowToWorldMatrix[3].y), _115);
      float _117 = mad(_79.x, (g_StaticShadowToWorldMatrix[3].z), _116);
      float _118 = _117 + (g_StaticShadowToWorldMatrix[3].w);
      float _129 = (g_WorldToDynamicShadowMatrix[2].x) * _106;
      float _130 = mad(_110, (g_WorldToDynamicShadowMatrix[2].y), _129);
      float _131 = mad(_114, (g_WorldToDynamicShadowMatrix[2].z), _130);
      float _132 = mad(_118, (g_WorldToDynamicShadowMatrix[2].w), _131);
      float _133 = (g_WorldToDynamicShadowMatrix[3].x) * _106;
      float _134 = mad(_110, (g_WorldToDynamicShadowMatrix[3].y), _133);
      float _135 = mad(_114, (g_WorldToDynamicShadowMatrix[3].z), _134);
      float _136 = mad(_118, (g_WorldToDynamicShadowMatrix[3].w), _135);
      float _137 = _132 / _136;
      _140 = _137;
    } else {
      _140 = 0.0f;
    }
  } else {
    if (true) discard;
    _140 = 0.0f;
  }
  SV_Depth = _140;
  return SV_Depth;
}
