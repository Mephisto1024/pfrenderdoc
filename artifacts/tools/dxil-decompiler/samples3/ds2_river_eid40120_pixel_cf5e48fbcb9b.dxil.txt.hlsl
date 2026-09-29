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
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace,
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
  float _45 = -0.0f - SV_Position.w;
  float _46 = _43 * SV_Position.w;
  float _47 = _44 * SV_Position.w;
  float _66 = _46 * (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[0].x);
  float _67 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[1].x), _47, _66);
  float _68 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[2].x), _45, _67);
  float _69 = _68 + (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[3].x);
  float _70 = _46 * (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[0].y);
  float _71 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[1].y), _47, _70);
  float _72 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[2].y), _45, _71);
  float _73 = _72 + (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[3].y);
  float _74 = _46 * (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[0].z);
  float _75 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[1].z), _47, _74);
  float _76 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[2].z), _45, _75);
  float _77 = _76 + (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[3].z);
  float _82 = _69 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.x;
  float _83 = _73 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.y;
  float _84 = _77 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.z;
  float _90 = _82 / Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_120;
  float _91 = _83 / Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_120;
  uint _97 = Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_008 * 31;
  float _98 = cb0_space2_233z - cb0_space2_233x;
  float _99 = cb0_space2_233w - cb0_space2_233y;
  float _100 = _82 - cb0_space2_233x;
  float _101 = _83 - cb0_space2_233y;
  float _102 = _100 / _98;
  float _103 = _101 / _99;
  float _104 = saturate(_102);
  float _105 = saturate(_103);
  SamplerState _107 = SamplerDescriptorHeap[17u];
  float4 _109 = t44_space2.SampleLevel(_107, float2(_104, _105), 0.0f);
  float _111 = _90 - Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_000.x;
  float _112 = 1.0f - _91;
  float _113 = _112 + Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_000.y;
  float _117 = 1.0f - (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_012);
  float _118 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_012) * 0.5f;
  float _119 = _117 * _111;
  float _120 = _117 * _113;
  float _121 = _119 + _118;
  float _122 = _120 + _118;
  int _125 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_240.x & 128;
  bool _126 = (_125 == 0);
  SamplerState _128 = SamplerDescriptorHeap[109u];
  float _161;
  float _205;
  float _450;
  float _451;
  float _452;
  float _528;
  float _587;
  float _629;
  float _630;
  float _631;
  float _632;
  float _771;
  float _772;
  float _773;
  float _774;
  float _775;
  float _776;
  float _777;
  float _778;
  float _779;
  float _780;
  float _781;
  float _782;
  float _785;
  float _786;
  float _787;
  float _788;
  float _789;
  float _790;
  float _791;
  float _847;
  if (!_126) {
    int _130 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_240.x & 127;
    float _131 = float((uint)_130);
    float _132 = _131 * 0.007874015718698502f;
    _161 = _132;
  } else {
    uint _137 = ((int)(Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_000)) + _97;
    uint _138 = _137 + 0u;
    float4 _141 = t0_space9[_138].SampleBias(_128, float2(_121, _122), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
    int _147 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_004) & 7;
    int _148 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[5].WorldDataTypePackingSRTData_004) & 6;
    bool _149 = (_148 == 6);
    bool _150 = (_147 == 0);
    bool _151 = _149 || _150;
    if (!_151) {
      bool _154 = (_147 == 1);
      if (!_154) {
        bool _156 = (_147 == 2);
        if (!_156) {
          bool _158 = (_147 == 3);
          float _159 = select(_158, _141.w, _141.x);
          _161 = _159;
        } else {
          _161 = _141.z;
        }
      } else {
        _161 = _141.y;
      }
    } else {
      _161 = _141.x;
    }
  }
  float _164 = 1.0f - _161;
  float _165 = _164 * _109.x;
  float _166 = _165 * Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_928.GlobalRenderVariablesSRT_064;
  float _167 = _166 + _161;
  bool _168 = (_167 > 0.5299999713897705f);
  float _173 = 1.0f - (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[1].WorldDataTypePackingSRTData_012);
  float _174 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[1].WorldDataTypePackingSRTData_012) * 0.5f;
  float _175 = _173 * _111;
  float _176 = _173 * _113;
  float _177 = _175 + _174;
  float _178 = _176 + _174;
  uint _181 = ((int)(Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[1].WorldDataTypePackingSRTData_000)) + _97;
  uint _182 = _181 + 0u;
  float4 _185 = t0_space9[_182].SampleBias(_128, float2(_177, _178), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  int _191 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[1].WorldDataTypePackingSRTData_004) & 7;
  int _192 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[1].WorldDataTypePackingSRTData_004) & 6;
  bool _193 = (_192 == 6);
  bool _194 = (_191 == 0);
  bool _195 = _193 || _194;
  if (!_195) {
    bool _198 = (_191 == 1);
    if (!_198) {
      bool _200 = (_191 == 2);
      if (!_200) {
        bool _202 = (_191 == 3);
        float _203 = select(_202, _185.w, _185.x);
        _205 = _203;
      } else {
        _205 = _185.z;
      }
    } else {
      _205 = _185.y;
    }
  } else {
    _205 = _185.x;
  }
  float _206 = _205 * 2048.0f;
  SamplerState _210 = SamplerDescriptorHeap[150u];
  Texture2D<float4> _214 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_000)];
  float4 _215 = _214.SampleBias(_210, float2(STAGE_IO_1.x, STAGE_IO_1.y), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  float _220 = max(_84, 0.0f);
  float _221 = min(_220, 1.0f);
  Texture2D<float3> _224 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_008)];
  float3 _225 = _224.SampleBias(_210, float2(STAGE_IO_1.x, STAGE_IO_1.y), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  Texture2D<float> _231 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_012)];
  float _232 = _231.SampleBias(_210, float2(STAGE_IO_1.x, STAGE_IO_1.y), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  uint _237 = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.StaticPerInstance_Constant_012 * STAGE_IO_5;
  uint _238 = _237 + (int)(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.StaticPerInstance_Constant_000);
  float4 _240 = t0_space7.Load(_238);
  int _244 = _238 + 1;
  float4 _245 = t0_space7.Load(_244);
  int _249 = _238 + 2;
  float4 _250 = t0_space7.Load(_249);
  int _254 = _238 + 3;
  float4 _255 = t0_space7.Load(_254);
  float _269 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _240.x;
  float _270 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _240.y, _269);
  float _271 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _240.z, _270);
  float _272 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _245.x;
  float _273 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _245.y, _272);
  float _274 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _245.z, _273);
  float _275 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _250.x;
  float _276 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _250.y, _275);
  float _277 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _250.z, _276);
  float _278 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _255.x;
  float _279 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _255.y, _278);
  float _280 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _255.z, _279);
  float _281 = _280 + (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].w);
  float _282 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _240.x;
  float _283 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _240.y, _282);
  float _284 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _240.z, _283);
  float _285 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _245.x;
  float _286 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _245.y, _285);
  float _287 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _245.z, _286);
  float _288 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _250.x;
  float _289 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _250.y, _288);
  float _290 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _250.z, _289);
  float _291 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _255.x;
  float _292 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _255.y, _291);
  float _293 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _255.z, _292);
  float _294 = _293 + (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].w);
  float _295 = _271 * STAGE_IO_2.x;
  float _296 = mad(_274, STAGE_IO_2.y, _295);
  float _297 = mad(_277, STAGE_IO_2.z, _296);
  float _298 = _281 + _297;
  float _299 = _284 * STAGE_IO_2.x;
  float _300 = mad(_287, STAGE_IO_2.y, _299);
  float _301 = mad(_290, STAGE_IO_2.z, _300);
  float _302 = _294 + _301;
  float _306 = _298 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.x;
  float _307 = _302 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.y;
  float _308 = _215.x * 2.0f;
  float _309 = _215.y * 2.0f;
  float _310 = _308 + -1.0f;
  float _311 = _309 + -1.0f;
  float _312 = dot(float2(_310, _311), float2(_310, _311));
  float _313 = 1.0f - _312;
  float _314 = saturate(_313);
  float _315 = sqrt(_314);
  float _316 = ceil(_221);
  float _317 = _84 - _206;
  float _318 = STAGE_IO.y * STAGE_IO_3.z;
  float _319 = STAGE_IO.z * STAGE_IO_3.y;
  float _320 = _318 - _319;
  float _321 = STAGE_IO.z * STAGE_IO_3.x;
  float _322 = STAGE_IO.x * STAGE_IO_3.z;
  float _323 = _321 - _322;
  float _324 = STAGE_IO.x * STAGE_IO_3.y;
  float _325 = STAGE_IO.y * STAGE_IO_3.x;
  float _326 = _324 - _325;
  bool _327 = (STAGE_IO_3.w > 0.25f);
  float _328 = select(_327, -1.0f, 1.0f);
  float _329 = _320 * _328;
  float _330 = _323 * _328;
  float _331 = _326 * _328;
  if (!_168) {
    float _335 = saturate(_215.z);
    float _336 = 1.0f - _335;
    int _337 = asint(_312);
    uint _338 = _337 >> 1;
    int _339 = _338 + 532369198;
    float _340 = asfloat(_339);
    float _341 = saturate(_340);
    float _342 = _341 * 0.4300000071525574f;
    float _343 = 0.8799999952316284f - _342;
    float _344 = _336 * 3.0f;
    float _345 = _344 + -1.0f;
    float _346 = max(_345, 0.0f);
    float _347 = min(_346, 1.0f);
    float _348 = _215.w * 3.0f;
    float _349 = 2.0f - _348;
    float _350 = saturate(_349);
    float _351 = _306 * 0.1666666716337204f;
    float _352 = _307 * 0.1666666716337204f;
    float _357 = (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_000[2].x) * STAGE_IO.x;
    float _358 = mad(STAGE_IO.y, (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_000[2].y), _357);
    float _359 = mad(STAGE_IO.z, (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_000[2].z), _358);
    float _360 = _343 + _350;
    float _361 = _347 + 0.5f;
    float _364 = _167 + -0.41999998688697815f;
    float _365 = _364 * -8.333334922790527f;
    float _366 = saturate(_365);
    float _367 = saturate(_360);
    float _368 = _361 * _361;
    SamplerState _370 = SamplerDescriptorHeap[132u];
    Texture2D<float3> _374 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_004)];
    float3 _375 = _374.SampleBias(_370, float2(_351, _352), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
    float _377 = _366 * 0.7799999713897705f;
    float _378 = _359 + -0.800000011920929f;
    float _379 = _378 * 5.55555534362793f;
    float _380 = saturate(_379);
    float _381 = _341 * 0.4000000059604645f;
    float _382 = -0.0f - ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_016;
    bool _383 = (ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_016 < -0.0f);
    bool _384 = (ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_016 > -0.0f);
    int _385 = (int)(uint)(_383);
    int _386 = (int)(uint)(_384);
    int _387 = _385 - _386;
    float _388 = float((int)(_387));
    float _389 = abs(_382);
    float _390 = _389 * _388;
    float _391 = _317 - ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_016;
    float _392 = _391 / _390;
    float _393 = saturate(_392);
    float _394 = max(_367, _377);
    float _395 = saturate(_359);
    float _396 = _380 * 0.33000001311302185f;
    float _397 = _368 * _366;
    float _398 = _393 * 1.100000023841858f;
    float _399 = _398 - _381;
    float _400 = saturate(_399);
    float _401 = _375.x * -0.800000011920929f;
    float _402 = _401 - _396;
    float _403 = _397 * 0.7920000553131104f;
    float _404 = _403 * _394;
    float _405 = _404 * _395;
    float _406 = _402 + _405;
    float _407 = saturate(_406);
    float _408 = _397 * 0.6666666865348816f;
    float _409 = _408 * _400;
    float _410 = max(_409, 0.0f);
    float _411 = min(_410, 1.0f);
    float _412 = max(_407, 0.0f);
    float _413 = min(_412, 1.0f);
    float _416 = 1.0f - (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_012);
    float _417 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_012) * 0.5f;
    float _418 = _416 * _111;
    float _419 = _416 * _113;
    float _420 = _418 + _417;
    float _421 = _419 + _417;
    uint _424 = ((int)(Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_000)) + _97;
    uint _425 = _424 + 0u;
    float4 _428 = t0_space9[_425].SampleBias(_128, float2(_420, _421), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
    int _435 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_004) & 7;
    int _436 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[97].WorldDataTypePackingSRTData_004) & 6;
    bool _437 = (_436 == 6);
    if (!_437) {
      bool _439 = (_435 == 0);
      if (!_439) {
        bool _441 = (_435 == 1);
        if (!_441) {
          bool _443 = (_435 == 2);
          if (!_443) {
            bool _445 = (_435 == 3);
            float _446 = select(_445, _428.w, _428.x);
            float _447 = select(_445, _428.w, _428.y);
            float _448 = select(_445, _428.w, _428.z);
            _450 = _446;
            _451 = _447;
            _452 = _448;
          } else {
            _450 = _428.z;
            _451 = _428.z;
            _452 = _428.z;
          }
        } else {
          _450 = _428.y;
          _451 = _428.y;
          _452 = _428.y;
        }
      } else {
        _450 = _428.x;
        _451 = _428.x;
        _452 = _428.x;
      }
    } else {
      _450 = _428.x;
      _451 = _428.y;
      _452 = _428.z;
    }
    float _453 = max(_413, _411);
    float _454 = _453 * _316;
    float _455 = 1.0f - _450;
    float _456 = 1.0f - _451;
    float _457 = 1.0f - _452;
    float _458 = _455 * 1.2000000476837158f;
    float _459 = _456 * 1.2000000476837158f;
    float _460 = _457 * 1.2000000476837158f;
    float _461 = 1.0f - _458;
    float _462 = 1.0f - _459;
    float _463 = 1.0f - _460;
    float _464 = _450 * 0.800000011920929f;
    float _465 = _451 * 0.800000011920929f;
    float _466 = _452 * 0.800000011920929f;
    bool _467 = (_450 < 0.5f);
    bool _468 = (_451 < 0.5f);
    bool _469 = (_452 < 0.5f);
    float _470 = select(_467, _464, _461);
    float _471 = select(_468, _465, _462);
    float _472 = select(_469, _466, _463);
    float _473 = saturate(_470);
    float _474 = saturate(_471);
    float _475 = saturate(_472);
    float _476 = 0.09700000286102295f - _232.x;
    float _477 = _454 * _476;
    float _478 = _477 + _232.x;
    float _479 = 0.10000000149011612f - _215.z;
    float _480 = _454 * _479;
    float _481 = _480 + _215.z;
    float _482 = _473 - _225.x;
    float _483 = _474 - _225.y;
    float _484 = _475 - _225.z;
    float _485 = _482 * _454;
    float _486 = _483 * _454;
    float _487 = _484 * _454;
    float _488 = _485 + _225.x;
    float _489 = _486 + _225.y;
    float _490 = _487 + _225.z;
    _771 = _481;
    _772 = _478;
    _773 = _488;
    _774 = _489;
    _775 = _490;
    _776 = 4.591152324323e-312f;
    _777 = 4.591152324323e-312f;
    _778 = 4.591152324323e-312f;
    _779 = 4.591152324323e-312f;
    _780 = 4.591152324323e-312f;
    _781 = 4.591152324323e-312f;
    _782 = 4.591152324323e-312f;
  } else {
    float _492 = _306 * 0.02222222276031971f;
    float _493 = _307 * 0.02222222276031971f;
    float _496 = 1.0f - (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[70].WorldDataTypePackingSRTData_012);
    float _497 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[70].WorldDataTypePackingSRTData_012) * 0.5f;
    float _498 = _496 * _111;
    float _499 = _496 * _113;
    float _500 = _498 + _497;
    float _501 = _499 + _497;
    uint _504 = ((int)(Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[70].WorldDataTypePackingSRTData_000)) + _97;
    uint _505 = _504 + 0u;
    float4 _508 = t0_space9[_505].SampleBias(_128, float2(_500, _501), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
    int _514 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[70].WorldDataTypePackingSRTData_004) & 7;
    int _515 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[70].WorldDataTypePackingSRTData_004) & 6;
    bool _516 = (_515 == 6);
    bool _517 = (_514 == 0);
    bool _518 = _516 || _517;
    if (!_518) {
      bool _521 = (_514 == 1);
      if (!_521) {
        bool _523 = (_514 == 2);
        if (!_523) {
          bool _525 = (_514 == 3);
          float _526 = select(_525, _508.w, _508.x);
          _528 = _526;
        } else {
          _528 = _508.z;
        }
      } else {
        _528 = _508.y;
      }
    } else {
      _528 = _508.x;
    }
    SamplerState _532 = SamplerDescriptorHeap[132u];
    Texture2D<float3> _536 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_004)];
    float3 _537 = _536.SampleBias(_532, float2(_492, _493), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
    float _539 = _83 * 0.00390625f;
    float _540 = _537.x * 20.0f;
    float _541 = _528 * 60.0f;
    float _542 = _82 * 0.00390625f;
    float _543 = _310 * STAGE_IO_3.x;
    float _544 = mad(_329, _311, _543);
    float _545 = mad(STAGE_IO.x, _315, _544);
    float _546 = _310 * STAGE_IO_3.y;
    float _547 = mad(_330, _311, _546);
    float _548 = mad(STAGE_IO.y, _315, _547);
    float _549 = _310 * STAGE_IO_3.z;
    float _550 = mad(_331, _311, _549);
    float _551 = mad(STAGE_IO.z, _315, _550);
    float _552 = frac(_539);
    float _555 = 1.0f - (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[14].WorldDataTypePackingSRTData_012);
    float _556 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[14].WorldDataTypePackingSRTData_012) * 0.5f;
    float _557 = _555 * _111;
    float _558 = _555 * _113;
    float _559 = _557 + _556;
    float _560 = _558 + _556;
    uint _563 = ((int)(Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[14].WorldDataTypePackingSRTData_000)) + _97;
    uint _564 = _563 + 0u;
    float4 _567 = t0_space9[_564].SampleBias(_128, float2(_559, _560), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
    int _573 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[14].WorldDataTypePackingSRTData_004) & 7;
    int _574 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[14].WorldDataTypePackingSRTData_004) & 6;
    bool _575 = (_574 == 6);
    bool _576 = (_573 == 0);
    bool _577 = _575 || _576;
    if (!_577) {
      bool _580 = (_573 == 1);
      if (!_580) {
        bool _582 = (_573 == 2);
        if (!_582) {
          bool _584 = (_573 == 3);
          float _585 = select(_584, _567.w, _567.x);
          _587 = _585;
        } else {
          _587 = _567.z;
        }
      } else {
        _587 = _567.y;
      }
    } else {
      _587 = _567.x;
    }
    float _588 = frac(_542);
    float _589 = _541 + -20.0f;
    float _590 = _589 + _540;
    float _595 = 1.0f - (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[26].WorldDataTypePackingSRTData_012);
    float _596 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[26].WorldDataTypePackingSRTData_012) * 0.5f;
    float _597 = _595 * _111;
    float _598 = _595 * _113;
    float _599 = _597 + _596;
    float _600 = _598 + _596;
    uint _603 = ((int)(Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[26].WorldDataTypePackingSRTData_000)) + _97;
    uint _604 = _603 + 0u;
    float4 _607 = t0_space9[_604].SampleBias(_128, float2(_599, _600), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
    int _614 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[26].WorldDataTypePackingSRTData_004) & 7;
    int _615 = (Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_016[26].WorldDataTypePackingSRTData_004) & 6;
    bool _616 = (_615 == 6);
    if (!_616) {
      bool _618 = (_614 == 0);
      if (!_618) {
        bool _620 = (_614 == 1);
        if (!_620) {
          bool _622 = (_614 == 2);
          if (!_622) {
            bool _624 = (_614 == 3);
            float _625 = select(_624, _607.w, _607.x);
            float _626 = select(_624, _607.w, _607.y);
            float _627 = select(_624, _607.w, _607.z);
            _629 = _625;
            _630 = _626;
            _631 = _627;
            _632 = _607.w;
          } else {
            _629 = _607.z;
            _630 = _607.z;
            _631 = _607.z;
            _632 = _607.z;
          }
        } else {
          _629 = _607.y;
          _630 = _607.y;
          _631 = _607.y;
          _632 = _607.y;
        }
      } else {
        _629 = _607.x;
        _630 = _607.x;
        _631 = _607.x;
        _632 = _607.x;
      }
    } else {
      _629 = _607.x;
      _630 = _607.y;
      _631 = _607.z;
      _632 = _607.w;
    }
    float _633 = _629 * 512.0f;
    float _634 = _630 * 512.0f;
    float _635 = _631 * 512.0f;
    float _636 = _632 * 512.0f;
    float _637 = _552 + -0.5f;
    float _638 = dot(float4(_633, _634, _635, _636), float4(1.0f, 0.015625f, 0.0f, 0.0f));
    float _639 = dot(float3(_545, _548, _551), float3(_545, _548, _551));
    float _640 = rsqrt(_639);
    float _641 = _640 * _545;
    float _642 = _640 * _548;
    float _643 = _640 * _551;
    float _644 = STAGE_IO_1.x * 3.0f;
    float _645 = STAGE_IO_1.y * 3.0f;
    float _646 = _588 + -0.5f;
    float _647 = _167 + -0.6000000238418579f;
    float _648 = _647 * 4.0f;
    float _649 = saturate(_648);
    float _650 = max(_590, 0.5f);
    float _657 = _641 * (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[0].z);
    float _658 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[1].z), _642, _657);
    float _659 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[2].z), _643, _658);
    float _660 = saturate(_649);
    float _661 = 1.0f - _660;
    SamplerState _665 = SamplerDescriptorHeap[122u];
    Texture2D<float3> _669 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_004)];
    float3 _670 = _669.SampleBias(_665, float2(_644, _645), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
    float _672 = abs(_637);
    float _673 = _650 * _649;
    float _674 = _587 + -0.3499999940395355f;
    float _675 = _674 * 6.666666507720947f;
    float _676 = saturate(_675);
    float _677 = abs(_646);
    float _678 = _315 * 4.999999046325684f;
    float _679 = _678 + -3.9999990463256836f;
    float _680 = saturate(_679);
    float _681 = _677 + -0.42500001192092896f;
    float _682 = _681 * 20.00000762939453f;
    float _683 = saturate(_682);
    float _684 = _661 * 0.4000000059604645f;
    float _685 = _84 + -0.5f;
    float _686 = _685 - _638;
    float _687 = _686 * -2.857142925262451f;
    float _688 = saturate(_687);
    float _689 = -0.10000000149011612f - _673;
    bool _690 = (_689 > 0.0f);
    bool _691 = (_689 < 0.0f);
    int _692 = (int)(uint)(_690);
    int _693 = (int)(uint)(_691);
    int _694 = _692 - _693;
    float _695 = float((int)(_694));
    float _696 = abs(_689);
    float _697 = _696 * _695;
    float _698 = _317 - _673;
    float _699 = _698 / _697;
    float _700 = saturate(_699);
    float _701 = _661 * 0.05999999865889549f;
    float _702 = _672 + -0.42500001192092896f;
    float _703 = _702 * 20.00000762939453f;
    float _704 = saturate(_703);
    float _705 = saturate(_676);
    float _706 = 1.0f - _705;
    float _707 = _659 * 0.5f;
    float _708 = _707 + 0.5f;
    float _709 = _701 + 0.949999988079071f;
    float _710 = max(_683, _704);
    float _711 = _700 * 1.5f;
    float _712 = _711 * _706;
    float _713 = _688 * _676;
    float _714 = _670.x * 0.3799999952316284f;
    float _715 = _684 + 0.6000000238418579f;
    float _716 = _710 * 2.0f;
    float _717 = saturate(_713);
    float _718 = 1.0f - _717;
    float _719 = _709 - _715;
    bool _720 = (_719 > 0.0f);
    bool _721 = (_719 < 0.0f);
    int _722 = (int)(uint)(_720);
    int _723 = (int)(uint)(_721);
    int _724 = _722 - _723;
    float _725 = float((int)(_724));
    float _726 = abs(_719);
    float _727 = _726 * _725;
    float _728 = _708 - _715;
    float _729 = _728 / _727;
    float _730 = saturate(_729);
    float _731 = _680 * -0.3499999940395355f;
    float _732 = _731 - _714;
    float _733 = _732 + _712;
    float _734 = _537.x * 0.5f;
    float _735 = _718 * 2.0f;
    float _736 = _735 * _730;
    float _737 = saturate(_733);
    float _738 = _716 - _734;
    float _739 = _680 * 0.800000011920929f;
    float _740 = _737 * 5.0f;
    float _741 = _740 + -2.0f;
    float _742 = max(_741, 0.0f);
    float _743 = min(_742, 1.0f);
    float _744 = _736 - _739;
    float _745 = saturate(_738);
    float _746 = saturate(_744);
    float _747 = _745 * _743;
    float _748 = _743 - _747;
    float _749 = max(_748, _746);
    float _750 = _749 * _316;
    float _751 = 0.1340000033378601f - _232.x;
    float _752 = _750 * _751;
    float _753 = _752 + _232.x;
    float _754 = 0.6940000057220459f - _225.x;
    float _755 = 0.6940000057220459f - _225.y;
    float _756 = 0.6940000057220459f - _225.z;
    float _757 = _750 * _754;
    float _758 = _750 * _755;
    float _759 = _750 * _756;
    float _760 = _757 + _225.x;
    float _761 = _758 + _225.y;
    float _762 = _759 + _225.z;
    float _763 = 0.20000000298023224f - _215.z;
    float _764 = _750 * _763;
    float _765 = _764 + _215.z;
    float _766 = 1.0f - _215.w;
    float _767 = _750 * _766;
    float _768 = _767 + _215.w;
    float _769 = _750 * 0.699999988079071f;
    _771 = 4.591152315785e-312f;
    _772 = 4.591152315785e-312f;
    _773 = 4.591152315785e-312f;
    _774 = 4.591152315785e-312f;
    _775 = 4.591152315785e-312f;
    _776 = _769;
    _777 = _768;
    _778 = _765;
    _779 = _753;
    _780 = _760;
    _781 = _761;
    _782 = _762;
  }
  if (!_168) {
    _785 = 0.0f;
    _786 = _215.w;
    _787 = _771;
    _788 = _772;
    _789 = _773;
    _790 = _774;
    _791 = _775;
  } else {
    _785 = _776;
    _786 = _777;
    _787 = _778;
    _788 = _779;
    _789 = _780;
    _790 = _781;
    _791 = _782;
  }
  float _797 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.x * SV_Position.x;
  float _798 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.y * SV_Position.y;
  float _799 = _798 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.w;
  float _800 = STAGE_IO_4.x / STAGE_IO_4.w;
  float _801 = STAGE_IO_4.y / STAGE_IO_4.w;
  float _802 = _310 * STAGE_IO_3.x;
  float _803 = mad(_329, _311, _802);
  float _804 = mad(STAGE_IO.x, _315, _803);
  float _805 = _310 * STAGE_IO_3.y;
  float _806 = mad(_330, _311, _805);
  float _807 = mad(STAGE_IO.y, _315, _806);
  float _808 = _310 * STAGE_IO_3.z;
  float _809 = mad(_331, _311, _808);
  float _810 = mad(STAGE_IO.z, _315, _809);
  float _811 = dot(float3(_804, _807, _810), float3(_804, _807, _810));
  float _812 = rsqrt(_811);
  float _813 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.z - _800;
  float _814 = _813 + _797;
  float _815 = _799 - _801;
  float _816 = _810 * 8.0f;
  float _817 = _816 * _812;
  float _818 = _817 + 8.000100135803223f;
  float _819 = sqrt(_818);
  float _820 = 1.0f / _819;
  float _821 = _820 * _812;
  float _822 = _821 * _804;
  float _823 = _821 * _807;
  float _824 = _822 + 0.5f;
  float _825 = _823 + 0.5f;
  float _826 = saturate(_785);
  float _827 = _826 * 247.0f;
  uint _828 = uint(_827);
  uint _829 = _828 << 5;
  int _830 = _829 & 128;
  int _831 = (uint)(_828) >> 5;
  int _832 = _831 & 4;
  int _833 = _828 & 16777083;
  int _834 = _832 | _833;
  int _835 = _834 | _830;
  uint _836 = _835 << 8;
  float _837 = f16tof32(_836);
  int _840 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_256.x & 7;
  bool _841 = (_840 == 7);
  if (!_841) {
    int _843 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_256.x & 8;
    bool _844 = (_843 != 0);
    float _845 = select(_844, 0.1882353127002716f, 0.3764706254005432f);
    _847 = _845;
  } else {
    _847 = 0.0f;
  }
  float _848 = max(_786, 0.30000001192092896f);
  float _849 = min(_848, 1.0f);
  float _850 = sqrt(_849);
  SV_Target.x = _789;
  SV_Target.y = _790;
  SV_Target.z = _791;
  SV_Target.w = _850;
  SV_Target_2.x = _824;
  SV_Target_2.y = _825;
  SV_Target_3.x = _787;
  SV_Target_3.y = _837;
  SV_Target_4.x = _788;
  SV_Target_4.y = _788;
  SV_Target_4.z = _788;
  SV_Target_4.w = _847;
  SV_Target_5.x = _814;
  SV_Target_5.y = _815;
  OutputSignature output_signature = { SV_Target, SV_Target_2, SV_Target_3, SV_Target_4, SV_Target_5 };
  return output_signature;
}
