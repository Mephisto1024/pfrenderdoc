struct MirrorSurfaceBindings_Constant {
  float4 MirrorSurfaceBindings_Constant_000[4];
  float4 MirrorSurfaceBindings_Constant_064[4];
  float4 MirrorSurfaceBindings_Constant_128;
  float4 MirrorSurfaceBindings_Constant_144;
  float4 MirrorSurfaceBindings_Constant_160;
  float4 MirrorSurfaceBindings_Constant_176;
  float4 MirrorSurfaceBindings_Constant_192;
  float4 MirrorSurfaceBindings_Constant_208;
  float4 MirrorSurfaceBindings_Constant_224;
};

struct OffscreenParams_Constant {
  float4 OffscreenParams_Constant_000[4];
  float OffscreenParams_Constant_064;
};

struct RasterizerVariables {
  float4 RasterizerVariables_000[4];
  float4 RasterizerVariables_064[4];
  float4 RasterizerVariables_128[4];
  float4 RasterizerVariables_192[3];
  int4 RasterizerVariables_240;
  int4 RasterizerVariables_256;
};

struct RasterizerVariablesExtended {
  float4 RasterizerVariablesExtended_000[4];
  float4 RasterizerVariablesExtended_064[4];
  float4 RasterizerVariablesExtended_128[4];
  float4 RasterizerVariablesExtended_192[4];
  float4 RasterizerVariablesExtended_256[4];
};

struct Scratch_PerFrame_Constants {
  struct GlobalConstants {
    float4 GlobalConstants_000;
    float4 GlobalConstants_016;
    float4 GlobalConstants_032;
    float3 GlobalConstants_048;
    float GlobalConstants_060;
    float4 GlobalConstants_064;
    float GlobalConstants_080;
    float GlobalConstants_084;
    float GlobalConstants_088;
    float GlobalConstants_092;
    float GlobalConstants_096;
    float GlobalConstants_100;
    float GlobalConstants_104;
    float GlobalConstants_108;
    float GlobalConstants_112;
    int GlobalConstants_116;
    float GlobalConstants_120;
    float GlobalConstants_124;
    int GlobalConstants_128;
    int GlobalConstants_132;
    int GlobalConstants_136;
    int GlobalConstants_140;
    float4 GlobalConstants_144;
    int GlobalConstants_160;
    float GlobalConstants_164;
    float GlobalConstants_168;
    int GlobalConstants_172;
  } Scratch_PerFrame_Constants_000;
  struct ShaderDebugConstants {
    float3 ShaderDebugConstants_000;
    float ShaderDebugConstants_012;
    float3 ShaderDebugConstants_016;
    float ShaderDebugConstants_028;
    float3 ShaderDebugConstants_032;
    float ShaderDebugConstants_044;
    float3 ShaderDebugConstants_048;
    float ShaderDebugConstants_060;
    float ShaderDebugConstants_064;
    float ShaderDebugConstants_068;
    float ShaderDebugConstants_072;
    float ShaderDebugConstants_076;
    float ShaderDebugConstants_080;
    float ShaderDebugConstants_084;
    float ShaderDebugConstants_088;
    float ShaderDebugConstants_092;
    float ShaderDebugConstants_096;
    float ShaderDebugConstants_100;
    float ShaderDebugConstants_104;
    float ShaderDebugConstants_108;
    int ShaderDebugConstants_112;
    int ShaderDebugConstants_116;
    int ShaderDebugConstants_120;
    int ShaderDebugConstants_124;
  } Scratch_PerFrame_Constants_176;
  OffscreenParams_Constant Scratch_PerFrame_Constants_304;
};

struct Scratch_PerInstance_Constants {
  RasterizerVariables Scratch_PerInstance_Constants_000;
  RasterizerVariablesExtended Scratch_PerInstance_Constants_272;
};

struct TarInteractionSampleParams_Constant {
  float4 TarInteractionSampleParams_Constant_000;
  float4 TarInteractionSampleParams_Constant_016;
  float4 TarInteractionSampleParams_Constant_032;
  float4 TarInteractionSampleParams_Constant_048;
  float4 TarInteractionSampleParams_Constant_064[4];
};

struct TerrainDeformationParams {
  int TerrainDeformationParams_000;
  float3 TerrainDeformationParams_004;
  float4 TerrainDeformationParams_016[4][16];
};

struct Scratch_PerPass_Constants {
  struct WaterInteractionSampleParams_Constant {
    float4 WaterInteractionSampleParams_Constant_000;
  } Scratch_PerPass_Constants_000;
  struct SnowInteractionSampleParams_Constant {
    float4 SnowInteractionSampleParams_Constant_000;
    float4 SnowInteractionSampleParams_Constant_016;
    float SnowInteractionSampleParams_Constant_032;
    float SnowInteractionSampleParams_Constant_036;
  } Scratch_PerPass_Constants_016;
  struct PrecipitationOcclusionSampleParams_Constant {
    float4 PrecipitationOcclusionSampleParams_Constant_000;
    float2 PrecipitationOcclusionSampleParams_Constant_016;
  } Scratch_PerPass_Constants_056;
  struct VegetationInteractionSampleParams_Constant {
    float4 VegetationInteractionSampleParams_Constant_000;
    float VegetationInteractionSampleParams_Constant_016;
  } Scratch_PerPass_Constants_080;
  struct FallenBushInteractionSampleParams_Constant {
    float4 FallenBushInteractionSampleParams_Constant_000;
  } Scratch_PerPass_Constants_100;
  struct FireSpreadSimulationSampleParams_Constant {
    float4 FireSpreadSimulationSampleParams_Constant_000;
    float4 FireSpreadSimulationSampleParams_Constant_016;
    float4 FireSpreadSimulationSampleParams_Constant_032;
  } Scratch_PerPass_Constants_116;
  TarInteractionSampleParams_Constant Scratch_PerPass_Constants_164;
  struct KJP3DPrintHeightSampleParams_Constant {
    float4 KJP3DPrintHeightSampleParams_Constant_000;
    float4 KJP3DPrintHeightSampleParams_Constant_016;
    float2 KJP3DPrintHeightSampleParams_Constant_032;
    float2 KJP3DPrintHeightSampleParams_Constant_040;
  } Scratch_PerPass_Constants_292;
  struct KnotSurfaceBindings_Constant {
    float KnotSurfaceBindings_Constant_000;
    float3 KnotSurfaceBindings_Constant_004;
  } Scratch_PerPass_Constants_340;
  MirrorSurfaceBindings_Constant Scratch_PerPass_Constants_356;
  struct WaveParticleAmbientOceanShaderParams {
    float2 WaveParticleAmbientOceanShaderParams_000;
    float WaveParticleAmbientOceanShaderParams_008;
    float WaveParticleAmbientOceanShaderParams_012;
    int WaveParticleAmbientOceanShaderParams_016;
    float WaveParticleAmbientOceanShaderParams_020;
    float WaveParticleAmbientOceanShaderParams_024;
    float WaveParticleAmbientOceanShaderParams_028;
    float3 WaveParticleAmbientOceanShaderParams_032;
    float WaveParticleAmbientOceanShaderParams_044;
    float3 WaveParticleAmbientOceanShaderParams_048;
    float WaveParticleAmbientOceanShaderParams_060;
    float3 WaveParticleAmbientOceanShaderParams_064;
    float WaveParticleAmbientOceanShaderParams_076;
    float4 WaveParticleAmbientOceanShaderParams_080[24];
    float4 WaveParticleAmbientOceanShaderParams_464[64];
  } Scratch_PerPass_Constants_596;
  struct WaterTessellationParameterOracle {
    float3 WaterTessellationParameterOracle_000;
    float WaterTessellationParameterOracle_012;
    float WaterTessellationParameterOracle_016;
    float WaterTessellationParameterOracle_020;
    float2 WaterTessellationParameterOracle_024;
    float2 WaterTessellationParameterOracle_032;
    float2 WaterTessellationParameterOracle_040;
  } Scratch_PerPass_Constants_2084;
  TerrainDeformationParams Scratch_PerPass_Constants_2132;
  struct WaterDeformationParams {
    int WaterDeformationParams_000;
    float3 WaterDeformationParams_004;
    float4 WaterDeformationParams_016[32];
  } Scratch_PerPass_Constants_3172;
  struct WeatherSystemParams_Constant {
    float4 WeatherSystemParams_Constant_000;
  } Scratch_PerPass_Constants_3700;
};

struct ViewConstants {
  float4 ViewConstants_000[4];
  float4 ViewConstants_064[4];
  float4 ViewConstants_128[4];
  float4 ViewConstants_192[4];
  float4 ViewConstants_256[4];
  float4 ViewConstants_320[4];
  float4 ViewConstants_384[4];
  float4 ViewConstants_448[4];
  float4 ViewConstants_512[4];
  float4 ViewConstants_576[4];
  float4 ViewConstants_640[4];
  float4 ViewConstants_704;
  float4 ViewConstants_720;
  float2 ViewConstants_736;
  float2 ViewConstants_744;
  float4 ViewConstants_752;
  float4 ViewConstants_768;
  float4 ViewConstants_784;
  float4 ViewConstants_800;
  float4 ViewConstants_816;
  float4 ViewConstants_832;
  float3 ViewConstants_848;
  float ViewConstants_860;
  float4 ViewConstants_864;
  float ViewConstants_880;
  float ViewConstants_884;
  float ViewConstants_888;
  float ViewConstants_892;
  float4 ViewConstants_896;
  float3 ViewConstants_912;
  float ViewConstants_924;
  struct GlobalRenderVariablesSRT {
    float GlobalRenderVariablesSRT_000;
    float GlobalRenderVariablesSRT_004;
    float GlobalRenderVariablesSRT_008;
    float GlobalRenderVariablesSRT_012;
    float GlobalRenderVariablesSRT_016;
    float GlobalRenderVariablesSRT_020;
    float GlobalRenderVariablesSRT_024;
    float GlobalRenderVariablesSRT_028;
    float GlobalRenderVariablesSRT_032;
    float GlobalRenderVariablesSRT_036;
    float GlobalRenderVariablesSRT_040;
    float GlobalRenderVariablesSRT_044;
    float GlobalRenderVariablesSRT_048;
    float GlobalRenderVariablesSRT_052;
    float GlobalRenderVariablesSRT_056;
    float GlobalRenderVariablesSRT_060;
    float GlobalRenderVariablesSRT_064;
    float GlobalRenderVariablesSRT_068;
    float GlobalRenderVariablesSRT_072;
    float GlobalRenderVariablesSRT_076;
  } ViewConstants_928;
  float4 ViewConstants_1008;
  float4 ViewConstants_1024;
  float4 ViewConstants_1040;
  float4 ViewConstants_1056;
  float4 ViewConstants_1072;
  float4 ViewConstants_1088;
  float4 ViewConstants_1104;
  float4 ViewConstants_1120;
  float4 ViewConstants_1136;
  float4 ViewConstants_1152;
  float4 ViewConstants_1168;
  float ViewConstants_1184;
  int ViewConstants_1188;
  float ViewConstants_1192;
};

struct Scratch_PerView_Constants {
  ViewConstants Scratch_PerView_Constants_000;
};


Texture2D<float4> t44_space2 : register(t44, space2);

Texture2D<float4> t0_space9[7440] : register(t0, space9);

Buffer<float4> t0_space7 : register(t0, space7);

cbuffer cb0_space1 : register(b0, space1) {
  Scratch_PerFrame_Constants Scratch_PerFrame_000 : packoffset(c000.x);
};

cbuffer cb0_space2 : register(b0, space2) {
  float cb0_space2_233x : packoffset(c233.x);
  float cb0_space2_233y : packoffset(c233.y);
  float cb0_space2_233z : packoffset(c233.z);
  float cb0_space2_233w : packoffset(c233.w);
};

cbuffer cb0_space3 : register(b0, space3) {
  Scratch_PerView_Constants Scratch_PerView_000 : packoffset(c000.x);
};

cbuffer cb0_space4 : register(b0, space4) {
  struct Scratch_PerTile_Constants {
    struct WorldDataTileSRTData {
      float2 WorldDataTileSRTData_000;
      int WorldDataTileSRTData_008;
      int WorldDataTileSRTData_012;
      struct WorldDataTypePackingSRTData {
        int WorldDataTypePackingSRTData_000;
        int WorldDataTypePackingSRTData_004;
        float WorldDataTypePackingSRTData_008;
        float WorldDataTypePackingSRTData_012;
      } WorldDataTileSRTData_016[160];
    } Scratch_PerTile_Constants_000;
  } Scratch_PerTile_000 : packoffset(c000.x);
};

cbuffer cb0_space6 : register(b0, space6) {
  Scratch_PerInstance_Constants Scratch_PerInstance_000 : packoffset(c000.x);
};

cbuffer cb0_space7 : register(b0, space7) {
  struct ShaderInstance_PerBatch_Constants {
    struct StaticPerBatch_Constant {
      int StaticPerBatch_Constant_000;
      int StaticPerBatch_Constant_004;
      int StaticPerBatch_Constant_008;
      float StaticPerBatch_Constant_012;
      float StaticPerBatch_Constant_016;
      float StaticPerBatch_Constant_020;
      float StaticPerBatch_Constant_024;
      float StaticPerBatch_Constant_028;
    } ShaderInstance_PerBatch_Constants_000;
  } ShaderInstance_PerBatch_000 : packoffset(c000.x);
};

cbuffer cb0_space8 : register(b0, space8) {
  struct ShaderInstance_PerInstance_Constants {
    struct StaticPerInstance_Constant {
      int StaticPerInstance_Constant_000;
      int StaticPerInstance_Constant_004;
      int StaticPerInstance_Constant_008;
      int StaticPerInstance_Constant_012;
      int StaticPerInstance_Constant_016;
    } ShaderInstance_PerInstance_Constants_000;
  } ShaderInstance_PerInstance_000 : packoffset(c000.x);
};

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float2 SV_Target_2 : SV_Target2;
  float2 SV_Target_3 : SV_Target3;
  float4 SV_Target_4 : SV_Target4;
  float2 SV_Target_5 : SV_Target5;
};

OutputSignature main(
  linear float3 STAGE_IO : STAGE_IO,
  linear float2 STAGE_IO_1 : STAGE_IO1,
  linear float3 STAGE_IO_2 : STAGE_IO2,
  linear float4 STAGE_IO_3 : STAGE_IO3,
  linear float4 STAGE_IO_4 : STAGE_IO4,
  nointerpolation uint STAGE_IO_5 : STAGE_IO5,
  noperspective float4 SV_Position : SV_Position
) {
  float4 SV_Target;
  float2 SV_Target_2;
  float2 SV_Target_3;
  float4 SV_Target_4;
  float2 SV_Target_5;
  float _41 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_896.x * SV_Position.x;
  float _42 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_896.y * SV_Position.y;
  float _43 = _41 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_896.z;
  float _44 = _42 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_896.w;
  float _45 = _43 * SV_Position.w;
  float _46 = _44 * SV_Position.w;
  float _47 = -0.0f - SV_Position.w;
  float _64 = _45 * (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[0].x);
  float _65 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[1].x), _46, _64);
  float _66 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[2].x), _47, _65);
  float _67 = _66 + (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[3].x);
  float _68 = _45 * (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[0].y);
  float _69 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[1].y), _46, _68);
  float _70 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[2].y), _47, _69);
  float _71 = _70 + (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[3].y);
  float _72 = _45 * (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[0].z);
  float _73 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[1].z), _46, _72);
  float _74 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[2].z), _47, _73);
  float _75 = _74 + (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[3].z);
  float _80 = _67 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.x;
  float _81 = _71 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.y;
  float _82 = _75 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.z;
  uint _93 = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.StaticPerInstance_Constant_012 * STAGE_IO_5;
  uint _94 = _93 + (int)(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.StaticPerInstance_Constant_000);
  float4 _96 = t0_space7.Load(_94);
  int _100 = _94 + 1;
  float4 _101 = t0_space7.Load(_100);
  int _105 = _94 + 2;
  float4 _106 = t0_space7.Load(_105);
  int _110 = _94 + 3;
  float4 _111 = t0_space7.Load(_110);
  float _125 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _96.x;
  float _126 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _96.y, _125);
  float _127 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _96.z, _126);
  float _128 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _101.x;
  float _129 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _101.y, _128);
  float _130 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _101.z, _129);
  float _131 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _106.x;
  float _132 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _106.y, _131);
  float _133 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _106.z, _132);
  float _134 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _111.x;
  float _135 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _111.y, _134);
  float _136 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _111.z, _135);
  float _137 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _96.x;
  float _138 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _96.y, _137);
  float _139 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _96.z, _138);
  float _140 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _101.x;
  float _141 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _101.y, _140);
  float _142 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _101.z, _141);
  float _143 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _106.x;
  float _144 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _106.y, _143);
  float _145 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _106.z, _144);
  float _146 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _111.x;
  float _147 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _111.y, _146);
  float _148 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _111.z, _147);
  float _149 = _127 * STAGE_IO_2.x;
  float _150 = mad(_130, STAGE_IO_2.y, _149);
  float _151 = mad(_133, STAGE_IO_2.z, _150);
  float _152 = _139 * STAGE_IO_2.x;
  float _153 = mad(_142, STAGE_IO_2.y, _152);
  float _154 = mad(_145, STAGE_IO_2.z, _153);
  float _155 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].w) + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.x;
  float _156 = _155 + _136;
  float _157 = _156 + _151;
  float _158 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].w) + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.y;
  float _159 = _158 + _148;
  float _160 = _159 + _154;
  float _161 = _80 / Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_120;
  float _162 = _81 / Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_120;
  float _163 = cb0_space2_233z - cb0_space2_233x;
  float _164 = cb0_space2_233w - cb0_space2_233y;
  float _165 = _80 - cb0_space2_233x;
  float _166 = _81 - cb0_space2_233y;
  float _167 = _165 / _163;
  float _168 = _166 / _164;
  float _169 = saturate(_167);
  float _170 = saturate(_168);
  uint _176 = Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_008 * 31;
  SamplerState _178 = SamplerDescriptorHeap[17u];
  float4 _180 = t44_space2.SampleLevel(_178, float2(_169, _170), 0.0f);
  float _182 = _161 - Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_000.x;
  float _183 = _162 - Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_000.y;
  float _184 = 1.0f - _183;
  float _185 = _157 / Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_120;
  float _186 = _160 / Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_120;
  float _192 = 1.0f - (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_012);
  float _193 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_012) * 0.5f;
  float _194 = _192 * _182;
  float _195 = _192 * _184;
  float _196 = _194 + _193;
  float _197 = _195 + _193;
  int _200 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_240.x & 128;
  bool _201 = (_200 == 0);
  SamplerState _203 = SamplerDescriptorHeap[109u];
  float _236;
  float _280;
  float _381;
  float _382;
  float _383;
  float _429;
  float _430;
  float _431;
  float _432;
  float _481;
  float _482;
  float _483;
  float _484;
  float _485;
  float _502;
  float _599;
  if (!_201) {
    int _205 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_240.x & 127;
    float _206 = float((uint)_205);
    float _207 = _206 * 0.007874015718698502f;
    _236 = _207;
  } else {
    uint _212 = ((int)(Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_000)) + _176;
    uint _213 = _212 + 0u;
    float4 _216 = t0_space9[_213].SampleBias(_203, float2(_196, _197), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
    int _222 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_004) & 7;
    int _223 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_004) & 6;
    bool _224 = (_223 == 6);
    bool _225 = (_222 == 0);
    bool _226 = _224 || _225;
    if (!_226) {
      bool _229 = (_222 == 1);
      if (!_229) {
        bool _231 = (_222 == 2);
        if (!_231) {
          bool _233 = (_222 == 3);
          float _234 = select(_233, _216.w, _216.x);
          _236 = _234;
        } else {
          _236 = _216.z;
        }
      } else {
        _236 = _216.y;
      }
    } else {
      _236 = _216.x;
    }
  }
  float _237 = _185 - Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_000.x;
  float _238 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_928.GlobalRenderVariablesSRT_064 * _180.x;
  float _239 = 1.0f - _236;
  float _240 = _238 * _239;
  float _241 = _240 + _236;
  float _242 = Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_000.y + 1.0f;
  float _243 = _242 - _186;
  float _248 = 1.0f - (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[13].WorldDataTypePackingSRTData_012);
  float _249 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[13].WorldDataTypePackingSRTData_012) * 0.5f;
  float _250 = _248 * _237;
  float _251 = _248 * _243;
  float _252 = _250 + _249;
  float _253 = _251 + _249;
  uint _256 = ((int)(Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[13].WorldDataTypePackingSRTData_000)) + _176;
  uint _257 = _256 + 0u;
  float4 _260 = t0_space9[_257].SampleBias(_203, float2(_252, _253), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  int _266 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[13].WorldDataTypePackingSRTData_004) & 7;
  int _267 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[13].WorldDataTypePackingSRTData_004) & 6;
  bool _268 = (_267 == 6);
  bool _269 = (_266 == 0);
  bool _270 = _268 || _269;
  if (!_270) {
    bool _273 = (_266 == 1);
    if (!_273) {
      bool _275 = (_266 == 2);
      if (!_275) {
        bool _277 = (_266 == 3);
        float _278 = select(_277, _260.w, _260.x);
        _280 = _278;
      } else {
        _280 = _260.z;
      }
    } else {
      _280 = _260.y;
    }
  } else {
    _280 = _260.x;
  }
  SamplerState _284 = SamplerDescriptorHeap[150u];
  Texture2D<float> _288 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_000)];
  float _289 = _288.SampleBias(_284, float2(STAGE_IO_1.x, STAGE_IO_1.y), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  Texture2D<float4> _293 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_004)];
  float4 _294 = _293.SampleBias(_284, float2(STAGE_IO_1.x, STAGE_IO_1.y), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  float _303 = (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_000[2].x) * STAGE_IO.x;
  float _304 = mad(STAGE_IO.y, (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_000[2].y), _303);
  float _305 = mad(STAGE_IO.z, (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_000[2].z), _304);
  float _308 = saturate(_289.x);
  float _309 = 1.0f - _308;
  float _310 = saturate(_294.z);
  float _311 = 1.0f - _310;
  float _312 = _241 * 2.0f;
  float _313 = 1.0f - _312;
  float _315 = _280 + -0.11999999731779099f;
  float _316 = _315 * -11.7647066116333f;
  float _317 = saturate(_316);
  float _319 = ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_024 - ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_020;
  bool _320 = (_319 > 0.0f);
  bool _321 = (_319 < 0.0f);
  int _322 = (int)(uint)(_320);
  int _323 = (int)(uint)(_321);
  int _324 = _322 - _323;
  float _325 = float((int)(_324));
  float _326 = abs(_319);
  float _327 = _325 * _326;
  float _328 = _313 - ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_020;
  float _329 = _328 / _327;
  float _330 = saturate(_329);
  float _331 = _305 + -0.75f;
  float _332 = _331 * 4.0f;
  float _333 = saturate(_332);
  float _334 = ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_016 + -1.0f;
  float _335 = _333 * _334;
  float _336 = _335 + 1.0f;
  float _337 = _317 * _317;
  float _338 = _309 * 1.5f;
  float _339 = saturate(_338);
  float _340 = _311 * 3.0f;
  float _341 = _340 + -1.0f;
  float _342 = max(_341, 0.0f);
  float _343 = min(_342, 1.0f);
  float _344 = max(_330, _337);
  float _347 = 1.0f - (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_012);
  float _348 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_012) * 0.5f;
  float _349 = _347 * _182;
  float _350 = _347 * _184;
  float _351 = _349 + _348;
  float _352 = _350 + _348;
  uint _355 = ((int)(Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_000)) + _176;
  uint _356 = _355 + 0u;
  float4 _359 = t0_space9[_356].SampleBias(_203, float2(_351, _352), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  int _366 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_004) & 7;
  int _367 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_004) & 6;
  bool _368 = (_367 == 6);
  if (!_368) {
    bool _370 = (_366 == 0);
    if (!_370) {
      bool _372 = (_366 == 1);
      if (!_372) {
        bool _374 = (_366 == 2);
        if (!_374) {
          bool _376 = (_366 == 3);
          float _377 = select(_376, _359.w, _359.x);
          float _378 = select(_376, _359.w, _359.y);
          float _379 = select(_376, _359.w, _359.z);
          _381 = _377;
          _382 = _378;
          _383 = _379;
        } else {
          _381 = _359.z;
          _382 = _359.z;
          _383 = _359.z;
        }
      } else {
        _381 = _359.y;
        _382 = _359.y;
        _383 = _359.y;
      }
    } else {
      _381 = _359.x;
      _382 = _359.x;
      _383 = _359.x;
    }
  } else {
    _381 = _359.x;
    _382 = _359.y;
    _383 = _359.z;
  }
  float _384 = _343 + 0.5f;
  float _385 = max(_336, _339);
  float _386 = saturate(STAGE_IO_2.z);
  float _387 = 1.0f - _386;
  float _390 = _385 * _344;
  float _395 = 1.0f - (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[26].WorldDataTypePackingSRTData_012);
  float _396 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[26].WorldDataTypePackingSRTData_012) * 0.5f;
  float _397 = _395 * _182;
  float _398 = _395 * _184;
  float _399 = _397 + _396;
  float _400 = _398 + _396;
  uint _403 = ((int)(Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[26].WorldDataTypePackingSRTData_000)) + _176;
  uint _404 = _403 + 0u;
  float4 _407 = t0_space9[_404].SampleBias(_203, float2(_399, _400), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  int _414 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[26].WorldDataTypePackingSRTData_004) & 7;
  int _415 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[26].WorldDataTypePackingSRTData_004) & 6;
  bool _416 = (_415 == 6);
  if (!_416) {
    bool _418 = (_414 == 0);
    if (!_418) {
      bool _420 = (_414 == 1);
      if (!_420) {
        bool _422 = (_414 == 2);
        if (!_422) {
          bool _424 = (_414 == 3);
          float _425 = select(_424, _407.w, _407.x);
          float _426 = select(_424, _407.w, _407.y);
          float _427 = select(_424, _407.w, _407.z);
          _429 = _425;
          _430 = _426;
          _431 = _427;
          _432 = _407.w;
        } else {
          _429 = _407.z;
          _430 = _407.z;
          _431 = _407.z;
          _432 = _407.z;
        }
      } else {
        _429 = _407.y;
        _430 = _407.y;
        _431 = _407.y;
        _432 = _407.y;
      }
    } else {
      _429 = _407.x;
      _430 = _407.x;
      _431 = _407.x;
      _432 = _407.x;
    }
  } else {
    _429 = _407.x;
    _430 = _407.y;
    _431 = _407.z;
    _432 = _407.w;
  }
  float _433 = _429 * 512.0f;
  float _434 = _430 * 512.0f;
  float _435 = _431 * 512.0f;
  float _436 = _432 * 512.0f;
  float _437 = _387 * _387;
  float _438 = dot(float4(_433, _434, _435, _436), float4(1.0f, 0.015625f, 0.0f, 0.0f));
  float _439 = ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_028 * 2.0f;
  float _440 = _439 + 1.0f;
  float _441 = _437 * _440;
  float _442 = _441 - ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_028;
  float _443 = max(_442, 0.0f);
  float _444 = min(_443, 1.0f);
  float _445 = saturate(_390);
  float _446 = saturate(_444);
  float _447 = _82 - _438;
  bool _448 = (_241 > 0.5099999904632568f);
  float _449 = _384 * _384;
  float _450 = _449 * 0.6666666865348816f;
  float _451 = _450 * _445;
  float _452 = _451 * _446;
  float _453 = _447 * 10.0f;
  float _454 = saturate(_453);
  float _455 = _241 + -0.6000000238418579f;
  float _456 = _455 * 3.333333969116211f;
  float _457 = saturate(_456);
  [branch]
  if (!_448) {
    float _459 = 1.0f - _383;
    float _460 = 1.0f - _382;
    float _461 = 1.0f - _381;
    bool _462 = (_383 < 0.5f);
    float _463 = _383 * 0.800000011920929f;
    float _464 = _459 * 1.2000000476837158f;
    float _465 = 1.0f - _464;
    float _466 = select(_462, _463, _465);
    float _467 = saturate(_466);
    bool _468 = (_382 < 0.5f);
    float _469 = _382 * 0.800000011920929f;
    float _470 = _460 * 1.2000000476837158f;
    float _471 = 1.0f - _470;
    float _472 = select(_468, _469, _471);
    float _473 = saturate(_472);
    bool _474 = (_381 < 0.5f);
    float _475 = _381 * 0.800000011920929f;
    float _476 = _461 * 1.2000000476837158f;
    float _477 = 1.0f - _476;
    float _478 = select(_474, _475, _477);
    float _479 = saturate(_478);
    _481 = _479;
    _482 = _473;
    _483 = _467;
    _484 = 0.10000000149011612f;
    _485 = 0.09700000286102295f;
  } else {
    _481 = 0.6940000057220459f;
    _482 = 0.6940000057220459f;
    _483 = 0.6940000057220459f;
    _484 = 0.20000000298023224f;
    _485 = 0.1340000033378601f;
  }
  float _486 = _457 * _454;
  float _487 = max(_452, 0.0f);
  float _488 = min(_487, 1.0f);
  Texture2D<float3> _494 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_008)];
  float3 _495 = _494.SampleBias(_284, float2(STAGE_IO_1.x, STAGE_IO_1.y), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  float _499 = select(_448, _486, _488);
  [branch]
  if (!_448) {
    _502 = 0.0f;
  } else {
    _502 = 0.699999988079071f;
  }
  float _503 = _294.x * 2.0f;
  float _504 = _294.y * 2.0f;
  float _505 = _503 + -1.0f;
  float _506 = _504 + -1.0f;
  float _507 = dot(float2(_505, _506), float2(_505, _506));
  float _508 = 1.0f - _507;
  float _509 = saturate(_508);
  float _510 = sqrt(_509);
  float _511 = _481 - _495.x;
  float _512 = _482 - _495.y;
  float _513 = _483 - _495.z;
  float _514 = _511 * _499;
  float _515 = _512 * _499;
  float _516 = _513 * _499;
  float _517 = _514 + _495.x;
  float _518 = _515 + _495.y;
  float _519 = _516 + _495.z;
  float _520 = _485 - _294.w;
  float _521 = _499 * _520;
  float _522 = _521 + _294.w;
  float _523 = _502 * _499;
  float _524 = _484 - _294.z;
  float _525 = _499 * _524;
  float _526 = _525 + _294.z;
  float _532 = STAGE_IO.y * STAGE_IO_3.z;
  float _533 = STAGE_IO.z * STAGE_IO_3.y;
  float _534 = _532 - _533;
  float _535 = STAGE_IO.z * STAGE_IO_3.x;
  float _536 = STAGE_IO.x * STAGE_IO_3.z;
  float _537 = _535 - _536;
  float _538 = STAGE_IO.x * STAGE_IO_3.y;
  float _539 = STAGE_IO.y * STAGE_IO_3.x;
  float _540 = _538 - _539;
  bool _541 = (STAGE_IO_3.w > 0.25f);
  float _542 = select(_541, -1.0f, 1.0f);
  float _543 = _534 * _542;
  float _544 = _537 * _542;
  float _545 = _540 * _542;
  float _546 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.x * SV_Position.x;
  float _547 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.y * SV_Position.y;
  float _548 = STAGE_IO_4.x / STAGE_IO_4.w;
  float _549 = STAGE_IO_4.y / STAGE_IO_4.w;
  float _550 = _505 * STAGE_IO_3.x;
  float _551 = mad(_543, _506, _550);
  float _552 = mad(STAGE_IO.x, _510, _551);
  float _553 = _505 * STAGE_IO_3.y;
  float _554 = mad(_544, _506, _553);
  float _555 = mad(STAGE_IO.y, _510, _554);
  float _556 = _505 * STAGE_IO_3.z;
  float _557 = mad(_545, _506, _556);
  float _558 = mad(STAGE_IO.z, _510, _557);
  float _559 = _547 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.w;
  float _560 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.z - _548;
  float _561 = _560 + _546;
  float _562 = _559 - _549;
  float _563 = dot(float3(_552, _555, _558), float3(_552, _555, _558));
  float _564 = rsqrt(_563);
  float _565 = max(_289.x, 0.30000001192092896f);
  float _566 = min(_565, 1.0f);
  float _567 = sqrt(_566);
  float _568 = saturate(_523);
  float _569 = _568 * 247.0f;
  uint _570 = uint(_569);
  uint _571 = _570 << 5;
  int _572 = _571 & 128;
  int _573 = (uint)(_570) >> 5;
  int _574 = _573 & 4;
  int _575 = _570 & 16777083;
  int _576 = _574 | _575;
  int _577 = _576 | _572;
  uint _578 = _577 << 8;
  float _579 = f16tof32(_578);
  float _580 = _558 * 8.0f;
  float _581 = _580 * _564;
  float _582 = _581 + 8.000100135803223f;
  float _583 = sqrt(_582);
  float _584 = 1.0f / _583;
  float _585 = _584 * _564;
  float _586 = _585 * _552;
  float _587 = _585 * _555;
  float _588 = _586 + 0.5f;
  float _589 = _587 + 0.5f;
  int _592 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_256.x & 7;
  bool _593 = (_592 == 7);
  if (!_593) {
    int _595 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_256.x & 8;
    bool _596 = (_595 != 0);
    float _597 = select(_596, 0.24313727021217346f, 0.43137258291244507f);
    _599 = _597;
  } else {
    _599 = 0.05490196496248245f;
  }
  SV_Target.x = _517;
  SV_Target.y = _518;
  SV_Target.z = _519;
  SV_Target.w = _567;
  SV_Target_2.x = _588;
  SV_Target_2.y = _589;
  SV_Target_3.x = _526;
  SV_Target_3.y = _579;
  SV_Target_4.x = _522;
  SV_Target_4.y = _522;
  SV_Target_4.z = _522;
  SV_Target_4.w = _599;
  SV_Target_5.x = _561;
  SV_Target_5.y = _562;
  OutputSignature output_signature = { SV_Target, SV_Target_2, SV_Target_3, SV_Target_4, SV_Target_5 };
  return output_signature;
}
