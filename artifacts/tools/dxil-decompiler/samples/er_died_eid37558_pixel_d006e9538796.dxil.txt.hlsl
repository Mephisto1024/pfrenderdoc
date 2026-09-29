cbuffer cbPaintParam : register(b10) {
  float4 FC_PaintMatrixDecalToWorld[4] : packoffset(c000.x);
  float4 FC_PaintMatrixView[4] : packoffset(c004.x);
  float4 FC_PaintParam : packoffset(c008.x);
  float4 FC_OccTexRcpSize : packoffset(c009.x);
  float4 FC_PaintMatrixWorldToDecal[3] : packoffset(c010.x);
  float4 FC_PaintCubeProjMatrix[4] : packoffset(c013.x);
  float4 g_PaintMaterialParamScale : packoffset(c017.x);
  float3 g_PaintMaterialParam_EmissiveScale : packoffset(c018.x);
  float cbPaintParam_pad0_w : packoffset(c018.w);
  float4 FC_PaintEraseColor : packoffset(c019.x);
  float4 FC_PaintModifyParam : packoffset(c020.x);
  int FC_Paint_EnableEmissive : packoffset(c021.x);
  int FC_Paint_FlipHorizontal : packoffset(c021.y);
  uint FC_Paint_DrawMask : packoffset(c021.z);
  uint cbPaintParam_pad1_w : packoffset(c021.w);
  float FC_NearFade_Start : packoffset(c022.x);
  float FC_NearFade_ReciRange : packoffset(c022.y);
  float FC_FarFade_Start : packoffset(c022.z);
  float FC_FarFade_ReciRange : packoffset(c022.w);
  float FC_NormalThreshold_Start : packoffset(c023.x);
  float FC_NormalThreshold_ReciRange : packoffset(c023.y);
  float cbPaintParam_pad2_z : packoffset(c023.z);
  float cbPaintParam_pad2_w : packoffset(c023.w);
};

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
  float4 SV_Target_2 : SV_Target2;
};

OutputSignature main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 COLOR : COLOR,
  linear float3 TEXCOORD : TEXCOORD
) {
  float4 SV_Target;
  float4 SV_Target_1;
  float4 SV_Target_2;
  float _5 = FC_PaintModifyParam.x - TEXCOORD.y;
  float _7 = _5 * FC_PaintModifyParam.y;
  float _8 = saturate(_7);
  float _14 = FC_PaintEraseColor.w * _8;
  SV_Target.x = FC_PaintEraseColor.x;
  SV_Target.y = FC_PaintEraseColor.y;
  SV_Target.z = FC_PaintEraseColor.z;
  SV_Target.w = _14;
  SV_Target_1.x = FC_PaintEraseColor.x;
  SV_Target_1.y = FC_PaintEraseColor.y;
  SV_Target_1.z = FC_PaintEraseColor.z;
  SV_Target_1.w = _14;
  SV_Target_2.x = FC_PaintEraseColor.x;
  SV_Target_2.y = FC_PaintEraseColor.y;
  SV_Target_2.z = FC_PaintEraseColor.z;
  SV_Target_2.w = _14;
  OutputSignature output_signature = { SV_Target, SV_Target_1, SV_Target_2 };
  return output_signature;
}
