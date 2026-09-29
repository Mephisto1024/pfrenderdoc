float main(
  nointerpolation uint STAGE_IO : STAGE_IO,
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float SV_Target;
  SV_Target = SV_Position.z;
  return SV_Target;
}
