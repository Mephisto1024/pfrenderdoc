cbuffer cbLightAccVtxParam : register(b4) {
  float g_vtxParam : packoffset(c000.x);
  float LIGHT_ACC_VTX_PARAM_PAD : packoffset(c000.y);
  float2 LIGHT_ACC_VTX_PARAM_PAD2 : packoffset(c000.z);
  float4 g_transformMatrix[4] : packoffset(c001.x);
};

cbuffer cbRendererCommonParam : register(b6) {
  float4 g_DynamicResolution_ScreenPercentage : packoffset(c000.x);
  float4 g_DynamicResolution_ScreenPercentage_Prev : packoffset(c001.x);
};

struct OutputSignature {
  noperspective float4 SV_Position : SV_Position;
  linear float2 TEXCOORD : TEXCOORD;
  linear float4 TEXCOORD_1 : TEXCOORD1;
};

OutputSignature main(
  float4 POSITION : POSITION,
  float2 TEXCOORD : TEXCOORD
) {
  float4 SV_Position;
  float2 TEXCOORD;
  float4 TEXCOORD_1;
  SV_Position.x = POSITION.x;
  SV_Position.y = POSITION.y;
  SV_Position.z = g_vtxParam;
  SV_Position.w = POSITION.w;
  float _13 = g_DynamicResolution_ScreenPercentage.x * TEXCOORD.x;
  float _14 = g_DynamicResolution_ScreenPercentage.y * TEXCOORD.y;
  TEXCOORD.x = _13;
  TEXCOORD.y = _14;
  TEXCOORD_1.x = POSITION.x;
  TEXCOORD_1.y = POSITION.y;
  TEXCOORD_1.z = g_vtxParam;
  TEXCOORD_1.w = POSITION.w;
  OutputSignature output_signature = { SV_Position, TEXCOORD, TEXCOORD_1 };
  return output_signature;
}
