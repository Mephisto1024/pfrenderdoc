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
      int StaticPerBatch_Constant_012;
      float StaticPerBatch_Constant_016;
      float StaticPerBatch_Constant_020;
      float StaticPerBatch_Constant_024;
      float StaticPerBatch_Constant_028;
      float StaticPerBatch_Constant_032;
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
  float _60 = _45 * (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[0].x);
  float _61 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[1].x), _46, _60);
  float _62 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[2].x), _47, _61);
  float _63 = _62 + (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[3].x);
  float _64 = _45 * (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[0].y);
  float _65 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[1].y), _46, _64);
  float _66 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[2].y), _47, _65);
  float _67 = _66 + (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[3].y);
  float _71 = _63 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.x;
  float _72 = _67 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.y;
  uint _83 = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.StaticPerInstance_Constant_012 * STAGE_IO_5;
  uint _84 = _83 + (int)(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.StaticPerInstance_Constant_000);
  float4 _86 = t0_space7.Load(_84);
  int _90 = _84 + 1;
  float4 _91 = t0_space7.Load(_90);
  int _95 = _84 + 2;
  float4 _96 = t0_space7.Load(_95);
  int _100 = _84 + 3;
  float4 _101 = t0_space7.Load(_100);
  float _115 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _86.x;
  float _116 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _86.y, _115);
  float _117 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _86.z, _116);
  float _118 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _91.x;
  float _119 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _91.y, _118);
  float _120 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _91.z, _119);
  float _121 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _96.x;
  float _122 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _96.y, _121);
  float _123 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _96.z, _122);
  float _124 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _101.x;
  float _125 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _101.y, _124);
  float _126 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _101.z, _125);
  float _127 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _86.x;
  float _128 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _86.y, _127);
  float _129 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _86.z, _128);
  float _130 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _91.x;
  float _131 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _91.y, _130);
  float _132 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _91.z, _131);
  float _133 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _96.x;
  float _134 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _96.y, _133);
  float _135 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _96.z, _134);
  float _136 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _101.x;
  float _137 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _101.y, _136);
  float _138 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _101.z, _137);
  float _139 = _117 * STAGE_IO_2.x;
  float _140 = mad(_120, STAGE_IO_2.y, _139);
  float _141 = mad(_123, STAGE_IO_2.z, _140);
  float _142 = _129 * STAGE_IO_2.x;
  float _143 = mad(_132, STAGE_IO_2.y, _142);
  float _144 = mad(_135, STAGE_IO_2.z, _143);
  float _145 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].w) + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.x;
  float _146 = _145 + _126;
  float _147 = _146 + _141;
  float _148 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].w) + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.y;
  float _149 = _148 + _138;
  float _150 = _149 + _144;
  float _151 = _71 / Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_120;
  float _152 = _72 / Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_120;
  float _153 = cb0_space2_233z - cb0_space2_233x;
  float _154 = cb0_space2_233w - cb0_space2_233y;
  float _155 = _71 - cb0_space2_233x;
  float _156 = _72 - cb0_space2_233y;
  float _157 = _155 / _153;
  float _158 = _156 / _154;
  float _159 = saturate(_157);
  float _160 = saturate(_158);
  uint _166 = Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_008 * 31;
  SamplerState _168 = SamplerDescriptorHeap[17u];
  float4 _170 = t44_space2.SampleLevel(_168, float2(_159, _160), 0.0f);
  float _172 = _151 - Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_000.x;
  float _173 = _152 - Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_000.y;
  float _174 = 1.0f - _173;
  float _175 = _147 / Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_120;
  float _176 = _150 / Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_120;
  float _182 = 1.0f - (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_012);
  float _183 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_012) * 0.5f;
  float _184 = _182 * _172;
  float _185 = _182 * _174;
  float _186 = _184 + _183;
  float _187 = _185 + _183;
  int _190 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_240.x & 128;
  bool _191 = (_190 == 0);
  SamplerState _193 = SamplerDescriptorHeap[109u];
  float _226;
  float _270;
  float _371;
  float _372;
  float _373;
  float _419;
  float _420;
  float _421;
  float _422;
  float _423;
  float _442;
  float _539;
  if (!_191) {
    int _195 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_240.x & 127;
    float _196 = float((uint)_195);
    float _197 = _196 * 0.007874015718698502f;
    _226 = _197;
  } else {
    uint _202 = ((int)(Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_000)) + _166;
    uint _203 = _202 + 0u;
    float4 _206 = t0_space9[_203].SampleBias(_193, float2(_186, _187), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
    int _212 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_004) & 7;
    int _213 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_004) & 6;
    bool _214 = (_213 == 6);
    bool _215 = (_212 == 0);
    bool _216 = _214 || _215;
    if (!_216) {
      bool _219 = (_212 == 1);
      if (!_219) {
        bool _221 = (_212 == 2);
        if (!_221) {
          bool _223 = (_212 == 3);
          float _224 = select(_223, _206.w, _206.x);
          _226 = _224;
        } else {
          _226 = _206.z;
        }
      } else {
        _226 = _206.y;
      }
    } else {
      _226 = _206.x;
    }
  }
  float _227 = _175 - Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_000.x;
  float _228 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_928.GlobalRenderVariablesSRT_064 * _170.x;
  float _229 = 1.0f - _226;
  float _230 = _228 * _229;
  float _231 = _230 + _226;
  float _232 = Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_000.y + 1.0f;
  float _233 = _232 - _176;
  float _238 = 1.0f - (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[13].WorldDataTypePackingSRTData_012);
  float _239 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[13].WorldDataTypePackingSRTData_012) * 0.5f;
  float _240 = _238 * _227;
  float _241 = _238 * _233;
  float _242 = _240 + _239;
  float _243 = _241 + _239;
  uint _246 = ((int)(Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[13].WorldDataTypePackingSRTData_000)) + _166;
  uint _247 = _246 + 0u;
  float4 _250 = t0_space9[_247].SampleBias(_193, float2(_242, _243), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  int _256 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[13].WorldDataTypePackingSRTData_004) & 7;
  int _257 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[13].WorldDataTypePackingSRTData_004) & 6;
  bool _258 = (_257 == 6);
  bool _259 = (_256 == 0);
  bool _260 = _258 || _259;
  if (!_260) {
    bool _263 = (_256 == 1);
    if (!_263) {
      bool _265 = (_256 == 2);
      if (!_265) {
        bool _267 = (_256 == 3);
        float _268 = select(_267, _250.w, _250.x);
        _270 = _268;
      } else {
        _270 = _250.z;
      }
    } else {
      _270 = _250.y;
    }
  } else {
    _270 = _250.x;
  }
  SamplerState _274 = SamplerDescriptorHeap[150u];
  Texture2D<float> _278 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_004)];
  float _279 = _278.SampleBias(_274, float2(STAGE_IO_1.x, STAGE_IO_1.y), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  Texture2D<float4> _283 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_008)];
  float4 _284 = _283.SampleBias(_274, float2(STAGE_IO_1.x, STAGE_IO_1.y), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  float _293 = (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_000[2].x) * STAGE_IO.x;
  float _294 = mad(STAGE_IO.y, (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_000[2].y), _293);
  float _295 = mad(STAGE_IO.z, (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_000[2].z), _294);
  float _298 = saturate(_279.x);
  float _299 = 1.0f - _298;
  float _300 = saturate(_284.z);
  float _301 = 1.0f - _300;
  float _302 = _231 * 2.0f;
  float _303 = 1.0f - _302;
  float _305 = _270 + -0.11999999731779099f;
  float _306 = _305 * -11.7647066116333f;
  float _307 = saturate(_306);
  float _309 = ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_028 - ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_024;
  bool _310 = (_309 > 0.0f);
  bool _311 = (_309 < 0.0f);
  int _312 = (int)(uint)(_310);
  int _313 = (int)(uint)(_311);
  int _314 = _312 - _313;
  float _315 = float((int)(_314));
  float _316 = abs(_309);
  float _317 = _315 * _316;
  float _318 = _303 - ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_024;
  float _319 = _318 / _317;
  float _320 = saturate(_319);
  float _321 = _295 + -0.75f;
  float _322 = _321 * 4.0f;
  float _323 = saturate(_322);
  float _324 = ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_020 + -1.0f;
  float _325 = _323 * _324;
  float _326 = _325 + 1.0f;
  float _327 = _307 * _307;
  float _328 = _299 * 1.5f;
  float _329 = saturate(_328);
  float _330 = _301 * 3.0f;
  float _331 = _330 + -1.0f;
  float _332 = max(_331, 0.0f);
  float _333 = min(_332, 1.0f);
  float _334 = max(_320, _327);
  float _337 = 1.0f - (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_012);
  float _338 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_012) * 0.5f;
  float _339 = _337 * _172;
  float _340 = _337 * _174;
  float _341 = _339 + _338;
  float _342 = _340 + _338;
  uint _345 = ((int)(Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_000)) + _166;
  uint _346 = _345 + 0u;
  float4 _349 = t0_space9[_346].SampleBias(_193, float2(_341, _342), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  int _356 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_004) & 7;
  int _357 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_004) & 6;
  bool _358 = (_357 == 6);
  if (!_358) {
    bool _360 = (_356 == 0);
    if (!_360) {
      bool _362 = (_356 == 1);
      if (!_362) {
        bool _364 = (_356 == 2);
        if (!_364) {
          bool _366 = (_356 == 3);
          float _367 = select(_366, _349.w, _349.x);
          float _368 = select(_366, _349.w, _349.y);
          float _369 = select(_366, _349.w, _349.z);
          _371 = _367;
          _372 = _368;
          _373 = _369;
        } else {
          _371 = _349.z;
          _372 = _349.z;
          _373 = _349.z;
        }
      } else {
        _371 = _349.y;
        _372 = _349.y;
        _373 = _349.y;
      }
    } else {
      _371 = _349.x;
      _372 = _349.x;
      _373 = _349.x;
    }
  } else {
    _371 = _349.x;
    _372 = _349.y;
    _373 = _349.z;
  }
  float _374 = _333 + 0.5f;
  float _375 = max(_326, _329);
  float _376 = STAGE_IO_2.z * 6.666666507720947f;
  float _377 = saturate(_376);
  float _378 = 1.0f - _377;
  float _381 = _375 * _334;
  float _382 = _378 * _378;
  float _383 = ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_032 * 2.0f;
  float _384 = _383 + 1.0f;
  float _385 = _382 * _384;
  float _386 = _385 - ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_032;
  float _387 = max(_386, 0.0f);
  float _388 = min(_387, 1.0f);
  float _389 = saturate(_381);
  float _390 = saturate(_388);
  bool _391 = (_231 > 0.5099999904632568f);
  float _392 = _374 * _374;
  float _393 = _392 * 0.6666666865348816f;
  float _394 = _393 * _389;
  float _395 = _394 * _390;
  [branch]
  if (!_391) {
    float _397 = 1.0f - _373;
    float _398 = 1.0f - _372;
    float _399 = 1.0f - _371;
    bool _400 = (_373 < 0.5f);
    float _401 = _373 * 0.800000011920929f;
    float _402 = _397 * 1.2000000476837158f;
    float _403 = 1.0f - _402;
    float _404 = select(_400, _401, _403);
    float _405 = saturate(_404);
    bool _406 = (_372 < 0.5f);
    float _407 = _372 * 0.800000011920929f;
    float _408 = _398 * 1.2000000476837158f;
    float _409 = 1.0f - _408;
    float _410 = select(_406, _407, _409);
    float _411 = saturate(_410);
    bool _412 = (_371 < 0.5f);
    float _413 = _371 * 0.800000011920929f;
    float _414 = _399 * 1.2000000476837158f;
    float _415 = 1.0f - _414;
    float _416 = select(_412, _413, _415);
    float _417 = saturate(_416);
    _419 = _417;
    _420 = _411;
    _421 = _405;
    _422 = 0.10000000149011612f;
    _423 = 0.09700000286102295f;
  } else {
    _419 = 0.6940000057220459f;
    _420 = 0.6940000057220459f;
    _421 = 0.6940000057220459f;
    _422 = 0.20000000298023224f;
    _423 = 0.1340000033378601f;
  }
  float _424 = _231 + -0.6000000238418579f;
  float _425 = _424 * 3.333333969116211f;
  float _426 = saturate(_425);
  float _427 = max(_395, 0.0f);
  float _428 = min(_427, 1.0f);
  Texture2D<float3> _434 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_012)];
  float3 _435 = _434.SampleBias(_274, float2(STAGE_IO_1.x, STAGE_IO_1.y), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  float _439 = select(_391, _426, _428);
  [branch]
  if (!_391) {
    _442 = 0.0f;
  } else {
    _442 = 0.699999988079071f;
  }
  float _443 = _284.x * 2.0f;
  float _444 = _284.y * 2.0f;
  float _445 = _443 + -1.0f;
  float _446 = _444 + -1.0f;
  float _447 = dot(float2(_445, _446), float2(_445, _446));
  float _448 = 1.0f - _447;
  float _449 = saturate(_448);
  float _450 = sqrt(_449);
  float _451 = _419 - _435.x;
  float _452 = _420 - _435.y;
  float _453 = _421 - _435.z;
  float _454 = _451 * _439;
  float _455 = _452 * _439;
  float _456 = _453 * _439;
  float _457 = _454 + _435.x;
  float _458 = _455 + _435.y;
  float _459 = _456 + _435.z;
  float _460 = _423 - _284.w;
  float _461 = _439 * _460;
  float _462 = _461 + _284.w;
  float _463 = _442 * _439;
  float _464 = _422 - _284.z;
  float _465 = _439 * _464;
  float _466 = _465 + _284.z;
  float _472 = STAGE_IO.y * STAGE_IO_3.z;
  float _473 = STAGE_IO.z * STAGE_IO_3.y;
  float _474 = _472 - _473;
  float _475 = STAGE_IO.z * STAGE_IO_3.x;
  float _476 = STAGE_IO.x * STAGE_IO_3.z;
  float _477 = _475 - _476;
  float _478 = STAGE_IO.x * STAGE_IO_3.y;
  float _479 = STAGE_IO.y * STAGE_IO_3.x;
  float _480 = _478 - _479;
  bool _481 = (STAGE_IO_3.w > 0.25f);
  float _482 = select(_481, -1.0f, 1.0f);
  float _483 = _474 * _482;
  float _484 = _477 * _482;
  float _485 = _480 * _482;
  float _486 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.x * SV_Position.x;
  float _487 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.y * SV_Position.y;
  float _488 = STAGE_IO_4.x / STAGE_IO_4.w;
  float _489 = STAGE_IO_4.y / STAGE_IO_4.w;
  float _490 = _445 * STAGE_IO_3.x;
  float _491 = mad(_483, _446, _490);
  float _492 = mad(STAGE_IO.x, _450, _491);
  float _493 = _445 * STAGE_IO_3.y;
  float _494 = mad(_484, _446, _493);
  float _495 = mad(STAGE_IO.y, _450, _494);
  float _496 = _445 * STAGE_IO_3.z;
  float _497 = mad(_485, _446, _496);
  float _498 = mad(STAGE_IO.z, _450, _497);
  float _499 = _487 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.w;
  float _500 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.z - _488;
  float _501 = _500 + _486;
  float _502 = _499 - _489;
  float _503 = dot(float3(_492, _495, _498), float3(_492, _495, _498));
  float _504 = rsqrt(_503);
  float _505 = max(_279.x, 0.30000001192092896f);
  float _506 = min(_505, 1.0f);
  float _507 = sqrt(_506);
  float _508 = saturate(_463);
  float _509 = _508 * 247.0f;
  uint _510 = uint(_509);
  uint _511 = _510 << 5;
  int _512 = _511 & 128;
  int _513 = (uint)(_510) >> 5;
  int _514 = _513 & 4;
  int _515 = _510 & 16777083;
  int _516 = _514 | _515;
  int _517 = _516 | _512;
  uint _518 = _517 << 8;
  float _519 = f16tof32(_518);
  float _520 = _498 * 8.0f;
  float _521 = _520 * _504;
  float _522 = _521 + 8.000100135803223f;
  float _523 = sqrt(_522);
  float _524 = 1.0f / _523;
  float _525 = _524 * _504;
  float _526 = _525 * _492;
  float _527 = _525 * _495;
  float _528 = _526 + 0.5f;
  float _529 = _527 + 0.5f;
  int _532 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_256.x & 7;
  bool _533 = (_532 == 7);
  if (!_533) {
    int _535 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_256.x & 8;
    bool _536 = (_535 != 0);
    float _537 = select(_536, 0.24313727021217346f, 0.43137258291244507f);
    _539 = _537;
  } else {
    _539 = 0.05490196496248245f;
  }
  SV_Target.x = _457;
  SV_Target.y = _458;
  SV_Target.z = _459;
  SV_Target.w = _507;
  SV_Target_2.x = _528;
  SV_Target_2.y = _529;
  SV_Target_3.x = _466;
  SV_Target_3.y = _519;
  SV_Target_4.x = _462;
  SV_Target_4.y = _462;
  SV_Target_4.z = _462;
  SV_Target_4.w = _539;
  SV_Target_5.x = _501;
  SV_Target_5.y = _502;
  OutputSignature output_signature = { SV_Target, SV_Target_2, SV_Target_3, SV_Target_4, SV_Target_5 };
  return output_signature;
}
