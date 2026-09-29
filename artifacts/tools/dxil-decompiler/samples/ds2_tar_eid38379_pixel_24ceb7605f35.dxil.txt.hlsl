struct OutputSignature {
  float SV_Target : SV_Target;
  float SV_Target_1 : SV_Target1;
};

OutputSignature main(
  noperspective float4 SV_Position : SV_Position,
  linear float LINEAR_DEPTH : LINEAR_DEPTH
) {
  float SV_Target;
  float SV_Target_1;
  SV_Target = LINEAR_DEPTH;
  SV_Target_1 = LINEAR_DEPTH;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
