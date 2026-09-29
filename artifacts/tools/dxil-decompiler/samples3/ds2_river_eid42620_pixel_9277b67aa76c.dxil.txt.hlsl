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


Texture2D<float4> t29_space2 : register(t29, space2);

Texture2D<float4> t44_space2 : register(t44, space2);

Texture2D<float4> t0_space9[7440] : register(t0, space9);

Buffer<float4> t0_space7 : register(t0, space7);

cbuffer cb0_space1 : register(b0, space1) {
  Scratch_PerFrame_Constants Scratch_PerFrame_000 : packoffset(c000.x);
};

cbuffer cb0_space2 : register(b0, space2) {
  float cb0_space2_009x : packoffset(c009.x);
  float cb0_space2_009y : packoffset(c009.y);
  float cb0_space2_009z : packoffset(c009.z);
  float cb0_space2_009w : packoffset(c009.w);
  float cb0_space2_010y : packoffset(c010.y);
  float cb0_space2_011y : packoffset(c011.y);
  float cb0_space2_016x : packoffset(c016.x);
  float cb0_space2_016y : packoffset(c016.y);
  float cb0_space2_016z : packoffset(c016.z);
  float cb0_space2_016w : packoffset(c016.w);
  float cb0_space2_017x : packoffset(c017.x);
  float cb0_space2_017y : packoffset(c017.y);
  float cb0_space2_017z : packoffset(c017.z);
  float cb0_space2_017w : packoffset(c017.w);
  float cb0_space2_018x : packoffset(c018.x);
  float cb0_space2_018y : packoffset(c018.y);
  float cb0_space2_018z : packoffset(c018.z);
  float cb0_space2_018w : packoffset(c018.w);
  float cb0_space2_019x : packoffset(c019.x);
  float cb0_space2_019y : packoffset(c019.y);
  float cb0_space2_019z : packoffset(c019.z);
  float cb0_space2_019w : packoffset(c019.w);
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

static const float _global_0[32] = { 0.4821484386920929f, 0.5200067758560181f, 0.5128511190414429f, 0.5804203152656555f, 0.7739860415458679f, 0.6445191502571106f, 0.384628564119339f, 0.35926416516304016f, 0.257485568523407f, 0.3739338517189026f, 0.6053813099861145f, 0.7023249864578247f, 0.7071558833122253f, 0.6095430850982666f, 0.4739968478679657f, 0.5851976275444031f, 0.7846363186836243f, 0.7485357522964478f, 0.5481436848640442f, 0.6277620792388916f, 0.6303774118423462f, 0.5891017913818359f, 0.679406464099884f, 0.6028133630752563f, 0.5887390375137329f, 0.631991446018219f, 0.674321711063385f, 0.6902437806129456f, 0.7559281587600708f, 0.6274029612541199f, 0.4701944887638092f, 0.5340685248374939f };

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float2 SV_Target_2 : SV_Target2;
  float2 SV_Target_3 : SV_Target3;
  float4 SV_Target_4 : SV_Target4;
  float2 SV_Target_5 : SV_Target5;
};

OutputSignature main(
  linear float2 STAGE_IO : STAGE_IO,
  linear float3 STAGE_IO_1 : STAGE_IO1,
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
  float _42 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_896.x * SV_Position.x;
  float _43 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_896.y * SV_Position.y;
  float _44 = _42 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_896.z;
  float _45 = _43 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_896.w;
  float _46 = _44 * SV_Position.w;
  float _47 = _45 * SV_Position.w;
  float _48 = -0.0f - SV_Position.w;
  float _63 = _46 * (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[0].x);
  float _64 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[1].x), _47, _63);
  float _65 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[2].x), _48, _64);
  float _66 = _65 + (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[3].x);
  float _67 = _46 * (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[0].y);
  float _68 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[1].y), _47, _67);
  float _69 = mad((Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[2].y), _48, _68);
  float _70 = _69 + (Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_192[3].y);
  float _74 = _66 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.x;
  float _75 = _70 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.y;
  float _81 = _74 / Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_120;
  float _82 = _75 / Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_120;
  uint _88 = Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_008 * 31;
  float _89 = cb0_space2_233z - cb0_space2_233x;
  float _90 = cb0_space2_233w - cb0_space2_233y;
  float _91 = _74 - cb0_space2_233x;
  float _92 = _75 - cb0_space2_233y;
  float _93 = _91 / _89;
  float _94 = _92 / _90;
  float _95 = saturate(_93);
  float _96 = saturate(_94);
  float _97 = _81 - Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_000.x;
  SamplerState _99 = SamplerDescriptorHeap[17u];
  float4 _101 = t44_space2.SampleLevel(_99, float2(_95, _96), 0.0f);
  float _103 = 1.0f - _82;
  float _104 = _103 + Scratch_PerTile_000.Scratch_PerTile_Constants_000.WorldDataTileSRTData_000.y;
  float _110 = _97 * 0.998046875f;
  float _111 = _104 * 0.998046875f;
  float _112 = _110 + 0.0009765625f;
  float _113 = _111 + 0.0009765625f;
  int _116 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_240.x & 128;
  bool _117 = (_116 == 0);
  float _133;
  float _173;
  float _180;
  float _187;
  float _190;
  float _191;
  float _208;
  float _235;
  float _259;
  float _284;
  float _285;
  float _286;
  float _418;
  float _419;
  float _420;
  float _573;
  float _586;
  float _593;
  float _594;
  float _595;
  float _660;
  float _661;
  float _662;
  float _738;
  float _874;
  float _875;
  float _876;
  float _877;
  float _878;
  float _879;
  float _927;
  if (!_117) {
    int _119 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_240.x & 127;
    float _120 = float((uint)_119);
    float _121 = _120 * 0.007874015718698502f;
    _133 = _121;
  } else {
    SamplerState _124 = SamplerDescriptorHeap[109u];
    uint _126 = _88 + 8u;
    uint _127 = _126 + 0u;
    float4 _130 = t0_space9[_127].SampleBias(_124, float2(_112, _113), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
    _133 = _130.w;
  }
  float _134 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_928.GlobalRenderVariablesSRT_064 * _101.x;
  float _135 = 1.0f - _133;
  float _136 = _134 * _135;
  float _137 = _136 + _133;
  bool _138 = (_137 > 0.550000011920929f);
  SamplerState _142 = SamplerDescriptorHeap[132u];
  Texture2D<float3> _146 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_004)];
  float3 _147 = _146.SampleBias(_142, float2(STAGE_IO.x, STAGE_IO.y), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  float _151 = max(_147.x, _147.y);
  float _152 = max(_151, _147.z);
  float _153 = min(_147.x, _147.y);
  float _154 = min(_153, _147.z);
  float _155 = _154 + _152;
  float _156 = _155 * 0.5f;
  bool _157 = (_154 == _152);
  if (!_157) {
    float _159 = _152 - _154;
    bool _160 = (_156 > 0.5f);
    float _161 = 2.0f - _152;
    float _162 = _161 - _154;
    float _163 = select(_160, _162, _155);
    float _164 = _159 / _163;
    bool _165 = (_147.x == _152);
    if (_165) {
      float _167 = _147.y - _147.z;
      float _168 = _167 / _159;
      bool _169 = (_147.y < _147.z);
      float _170 = select(_169, 6.0f, 0.0f);
      float _171 = _168 + _170;
      _173 = _171;
    } else {
      _173 = 0.0f;
    }
    bool _174 = (_147.y == _152);
    if (_174) {
      float _176 = _147.z - _147.x;
      float _177 = _176 / _159;
      float _178 = _177 + 2.0f;
      _180 = _178;
    } else {
      _180 = _173;
    }
    bool _181 = (_147.z == _152);
    if (_181) {
      float _183 = _147.x - _147.y;
      float _184 = _183 / _159;
      float _185 = _184 + 4.0f;
      _187 = _185;
    } else {
      _187 = _180;
    }
    float _188 = _187 * 0.1666666716337204f;
    _190 = _188;
    _191 = _164;
  } else {
    _190 = 0.0f;
    _191 = 0.0f;
  }
  float _192 = max(_191, 0.0f);
  float _193 = min(_192, 1.0f);
  float _194 = _190 + -0.029990000650286674f;
  float _195 = max(_156, 0.0f);
  float _196 = min(_195, 1.0f);
  bool _197 = (_193 == 0.0f);
  if (!_197) {
    bool _199 = (_196 < 0.5f);
    if (_199) {
      float _201 = _193 + 1.0f;
      float _202 = _196 * _201;
      _208 = _202;
    } else {
      float _204 = _196 + _193;
      float _205 = _196 * _193;
      float _206 = _204 - _205;
      _208 = _206;
    }
    float _209 = _196 * 2.0f;
    float _210 = _209 - _208;
    float _211 = _190 + 0.30334335565567017f;
    bool _212 = (_211 < 0.0f);
    float _213 = _190 + 1.3033432960510254f;
    float _214 = select(_212, _213, _211);
    bool _215 = (_214 > 1.0f);
    float _216 = _214 + -1.0f;
    float _217 = select(_215, _216, _214);
    bool _218 = (_217 < 0.1666666716337204f);
    if (_218) {
      float _220 = _208 - _210;
      float _221 = _217 * 6.0f;
      float _222 = _221 * _220;
      float _223 = _222 + _210;
      _235 = _223;
    } else {
      bool _225 = (_217 < 0.5f);
      if (!_225) {
        bool _227 = (_217 < 0.6666666865348816f);
        if (_227) {
          float _229 = _208 - _210;
          float _230 = 0.6666666865348816f - _217;
          float _231 = _230 * 6.0f;
          float _232 = _231 * _229;
          float _233 = _232 + _210;
          _235 = _233;
        } else {
          _235 = _210;
        }
      } else {
        _235 = _208;
      }
    }
    bool _236 = (_194 < 0.0f);
    float _237 = _190 + 0.970009982585907f;
    float _238 = select(_236, _237, _194);
    bool _239 = (_238 > 1.0f);
    float _240 = _238 + -1.0f;
    float _241 = select(_239, _240, _238);
    bool _242 = (_241 < 0.1666666716337204f);
    if (_242) {
      float _244 = _208 - _210;
      float _245 = _241 * 6.0f;
      float _246 = _245 * _244;
      float _247 = _246 + _210;
      _259 = _247;
    } else {
      bool _249 = (_241 < 0.5f);
      if (!_249) {
        bool _251 = (_241 < 0.6666666865348816f);
        if (_251) {
          float _253 = _208 - _210;
          float _254 = 0.6666666865348816f - _241;
          float _255 = _254 * 6.0f;
          float _256 = _255 * _253;
          float _257 = _256 + _210;
          _259 = _257;
        } else {
          _259 = _210;
        }
      } else {
        _259 = _208;
      }
    }
    float _260 = _190 + -0.3633233308792114f;
    bool _261 = (_260 < 0.0f);
    float _262 = _190 + 0.6366766691207886f;
    float _263 = select(_261, _262, _260);
    bool _264 = (_263 > 1.0f);
    float _265 = _263 + -1.0f;
    float _266 = select(_264, _265, _263);
    bool _267 = (_266 < 0.1666666716337204f);
    if (_267) {
      float _269 = _208 - _210;
      float _270 = _266 * 6.0f;
      float _271 = _270 * _269;
      float _272 = _271 + _210;
      _284 = _235;
      _285 = _259;
      _286 = _272;
    } else {
      bool _274 = (_266 < 0.5f);
      if (!_274) {
        bool _276 = (_266 < 0.6666666865348816f);
        if (_276) {
          float _278 = _208 - _210;
          float _279 = 0.6666666865348816f - _266;
          float _280 = _279 * 6.0f;
          float _281 = _280 * _278;
          float _282 = _281 + _210;
          _284 = _235;
          _285 = _259;
          _286 = _282;
        } else {
          _284 = _235;
          _285 = _259;
          _286 = _210;
        }
      } else {
        _284 = _235;
        _285 = _259;
        _286 = _208;
      }
    }
  } else {
    _284 = _196;
    _285 = _196;
    _286 = _196;
  }
  float _287 = max(_284, _285);
  float _288 = max(_287, _286);
  float _289 = min(_284, _285);
  float _290 = min(_289, _286);
  float _291 = _290 + _288;
  uint _295 = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.StaticPerInstance_Constant_012 * STAGE_IO_5;
  uint _296 = _295 + (int)(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.StaticPerInstance_Constant_000);
  float4 _298 = t0_space7.Load(_296);
  int _302 = _296 + 1;
  float4 _303 = t0_space7.Load(_302);
  int _307 = _296 + 2;
  float4 _308 = t0_space7.Load(_307);
  int _312 = _296 + 3;
  float4 _313 = t0_space7.Load(_312);
  float _327 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _298.x;
  float _328 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _298.y, _327);
  float _329 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _298.z, _328);
  float _330 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _303.x;
  float _331 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _303.y, _330);
  float _332 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _303.z, _331);
  float _333 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _308.x;
  float _334 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _308.y, _333);
  float _335 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _308.z, _334);
  float _336 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _313.x;
  float _337 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _313.y, _336);
  float _338 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _313.z, _337);
  float _339 = _338 + (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].w);
  float _340 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _298.x;
  float _341 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _298.y, _340);
  float _342 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _298.z, _341);
  float _343 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _303.x;
  float _344 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _303.y, _343);
  float _345 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _303.z, _344);
  float _346 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _308.x;
  float _347 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _308.y, _346);
  float _348 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _308.z, _347);
  float _349 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _313.x;
  float _350 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _313.y, _349);
  float _351 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _313.z, _350);
  float _352 = _351 + (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].w);
  float _353 = _329 * STAGE_IO_1.x;
  float _354 = mad(_332, STAGE_IO_1.y, _353);
  float _355 = mad(_335, STAGE_IO_1.z, _354);
  float _356 = _339 + _355;
  float _357 = _342 * STAGE_IO_1.x;
  float _358 = mad(_345, STAGE_IO_1.y, _357);
  float _359 = mad(_348, STAGE_IO_1.z, _358);
  float _360 = _352 + _359;
  float _364 = _356 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.x;
  float _365 = _360 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.y;
  float _366 = _364 * 0.0078125f;
  float _367 = _365 * 0.0078125f;
  Texture2D<float3> _373 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_008)];
  float3 _374 = _373.SampleBias(_142, float2(_366, _367), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  float _378 = ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_024 * _291;
  float _379 = _378 * 0.2150000035762787f;
  float _380 = _378 * 0.16500000655651093f;
  float _381 = _378 * 0.07000000029802322f;
  float _382 = _374.y + -0.20000000298023224f;
  float _383 = _382 * 1.25f;
  float _384 = saturate(_383);
  float _386 = max(_379, 0.0f);
  float _387 = max(_380, 0.0f);
  float _388 = max(_381, 0.0f);
  float _389 = min(_386, 1.0f);
  float _390 = min(_387, 1.0f);
  float _391 = min(_388, 1.0f);
  float _392 = _389 - _284;
  float _393 = _390 - _285;
  float _394 = _391 - _286;
  float _395 = _392 * _384;
  float _396 = _393 * _384;
  float _397 = _394 * _384;
  float _398 = _395 + _284;
  float _399 = _396 + _285;
  float _400 = _397 + _286;
  float _401 = _398 * ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_020;
  float _402 = _399 * ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_020;
  float _403 = _400 * ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_020;
  if (_138) {
    float _405 = _137 + -0.6000000238418579f;
    float _406 = _405 * 10.000003814697266f;
    float _407 = saturate(_406);
    float _408 = 0.6940000057220459f - _401;
    float _409 = 0.6940000057220459f - _402;
    float _410 = 0.6940000057220459f - _403;
    float _411 = _407 * _408;
    float _412 = _407 * _409;
    float _413 = _407 * _410;
    float _414 = _411 + _401;
    float _415 = _412 + _402;
    float _416 = _413 + _403;
    _418 = _414;
    _419 = _415;
    _420 = _416;
  } else {
    _418 = 0.0f;
    _419 = 0.0f;
    _420 = 0.0f;
  }
  float _441 = cb0_space2_016x - _74;
  float _442 = cb0_space2_016y - _75;
  float _443 = _441 * _441;
  float _444 = _442 * _442;
  float _445 = _443 + _444;
  float _446 = sqrt(_445);
  float _447 = _446 - cb0_space2_016z;
  bool _448 = (cb0_space2_016w > 0.0f);
  bool _449 = (_447 < 10000000272564224.0f);
  bool _450 = _448 && _449;
  float _451 = select(_450, cb0_space2_016x, 0.0f);
  float _452 = select(_450, cb0_space2_016y, 0.0f);
  float _453 = select(_450, cb0_space2_016z, 0.0f);
  float _454 = select(_450, cb0_space2_016w, 0.0f);
  float _455 = select(_450, _447, 10000000272564224.0f);
  float _456 = cb0_space2_017x - _74;
  float _457 = cb0_space2_017y - _75;
  float _458 = _456 * _456;
  float _459 = _457 * _457;
  float _460 = _458 + _459;
  float _461 = sqrt(_460);
  float _462 = _461 - cb0_space2_017z;
  bool _463 = (cb0_space2_017w > 0.0f);
  bool _464 = (_462 < _455);
  bool _465 = _463 && _464;
  float _466 = select(_465, cb0_space2_017x, _451);
  float _467 = select(_465, cb0_space2_017y, _452);
  float _468 = select(_465, cb0_space2_017z, _453);
  float _469 = select(_465, cb0_space2_017w, _454);
  float _470 = select(_465, _462, _455);
  float _471 = cb0_space2_018x - _74;
  float _472 = cb0_space2_018y - _75;
  float _473 = _471 * _471;
  float _474 = _472 * _472;
  float _475 = _473 + _474;
  float _476 = sqrt(_475);
  float _477 = _476 - cb0_space2_018z;
  bool _478 = (cb0_space2_018w > 0.0f);
  bool _479 = (_477 < _470);
  bool _480 = _478 && _479;
  float _481 = select(_480, cb0_space2_018x, _466);
  float _482 = select(_480, cb0_space2_018y, _467);
  float _483 = select(_480, cb0_space2_018z, _468);
  float _484 = select(_480, cb0_space2_018w, _469);
  float _485 = select(_480, _477, _470);
  float _486 = cb0_space2_019x - _74;
  float _487 = cb0_space2_019y - _75;
  float _488 = _486 * _486;
  float _489 = _487 * _487;
  float _490 = _488 + _489;
  float _491 = sqrt(_490);
  float _492 = _491 - cb0_space2_019z;
  bool _493 = (cb0_space2_019w > 0.0f);
  bool _494 = (_492 < _485);
  bool _495 = _493 && _494;
  float _496 = select(_495, cb0_space2_019x, _481);
  float _497 = select(_495, cb0_space2_019y, _482);
  float _498 = select(_495, cb0_space2_019z, _483);
  float _499 = select(_495, cb0_space2_019w, _484);
  float _500 = _74 - _496;
  float _501 = _75 - _497;
  float _502 = _501 / _500;
  float _503 = atan(_502);
  float _504 = _503 + 3.1415927410125732f;
  float _505 = _503 + -3.1415927410125732f;
  bool _506 = (_500 < 0.0f);
  bool _507 = (_500 == 0.0f);
  bool _508 = (_501 >= 0.0f);
  bool _509 = (_501 < 0.0f);
  bool _510 = _506 && _508;
  float _511 = select(_510, _504, _503);
  bool _512 = _506 && _509;
  float _513 = select(_512, _505, _511);
  bool _514 = _507 && _509;
  bool _515 = _507 && _508;
  float _516 = _513 * 0.15915493667125702f;
  float _517 = _516 + 0.5f;
  float _518 = select(_514, 0.25f, _517);
  float _519 = select(_515, 0.75f, _518);
  float _520 = frac(_519);
  float _521 = _520 * 8.0f;
  float _522 = -0.0f - _521;
  bool _523 = (_521 >= _522);
  float _524 = abs(_521);
  float _525 = frac(_524);
  float _526 = -0.0f - _525;
  float _527 = select(_523, _525, _526);
  float _528 = _527 * 32.0f;
  float _529 = floor(_528);
  float _530 = _529 + 1.0f;
  float _531 = _530 * 0.03125f;
  float _532 = -0.0f - _531;
  bool _533 = (_531 >= _532);
  float _534 = abs(_531);
  float _535 = frac(_534);
  float _536 = -0.0f - _535;
  float _537 = select(_533, _535, _536);
  float _538 = _537 * 32.0f;
  float _539 = _528 - _529;
  int _540 = int(_538);
  float _542 = _global_0[_540];
  int _543 = int(_529);
  float _545 = _global_0[_543];
  float _546 = _542 - _545;
  float _547 = _546 * _539;
  float _548 = _547 + _545;
  float _549 = _498 * 0.25f;
  float _550 = min(_549, 4.0f);
  float _551 = _548 * _550;
  float _552 = _498 + -0.5f;
  float _553 = _552 + _551;
  bool _554 = (_499 > 0.0f);
  float _555 = select(_138, _418, _401);
  float _556 = select(_138, _419, _402);
  float _557 = select(_138, _420, _403);
  float _558 = max(_555, _556);
  float _559 = max(_558, _557);
  float _560 = min(_555, _556);
  float _561 = min(_560, _557);
  float _562 = _561 + _559;
  bool _563 = (_561 == _559);
  if (!_563) {
    float _565 = _562 * 0.5f;
    float _566 = _559 - _561;
    bool _567 = (_565 > 0.5f);
    float _568 = 2.0f - _559;
    float _569 = _568 - _561;
    float _570 = select(_567, _569, _562);
    float _571 = _566 / _570;
    _573 = _571;
  } else {
    _573 = 0.0f;
  }
  float _574 = _562 * 0.36000001430511475f;
  bool _575 = (_573 == 0.0f);
  if (!_575) {
    bool _577 = (_574 < 0.5f);
    if (_577) {
      float _579 = _573 + 1.0f;
      float _580 = _579 * _574;
      _586 = _580;
    } else {
      float _582 = _573 + _574;
      float _583 = _573 * _574;
      float _584 = _582 - _583;
      _586 = _584;
    }
    float _587 = _562 * 0.7200000286102295f;
    float _588 = _587 - _586;
    float _589 = _586 - _588;
    float _590 = _589 * 0.4886363744735718f;
    float _591 = _590 + _588;
    _593 = _586;
    _594 = _591;
    _595 = _588;
  } else {
    _593 = _574;
    _594 = _574;
    _595 = _574;
  }
  float _598 = _593 - _555;
  float _599 = _594 - _556;
  float _600 = _595 - _557;
  float _601 = Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_104 * _598;
  float _602 = Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_104 * _599;
  float _603 = Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_104 * _600;
  float _604 = _601 + _555;
  float _605 = _602 + _556;
  float _606 = _603 + _557;
  if (_554) {
    float _608 = _553 + 1.0f;
    float _609 = _553 + 2.0f;
    float _610 = _608 / _609;
    float _611 = 1.0f / _553;
    float _612 = _611 * _500;
    float _613 = _611 * _501;
    float _614 = _612 * _612;
    float _615 = _613 * _613;
    float _616 = _615 + _614;
    float _617 = sqrt(_616);
    float _618 = saturate(_617);
    float _619 = 1.0f - _618;
    SamplerState _623 = SamplerDescriptorHeap[109u];
    uint _624 = _88 + 23u;
    uint _625 = _624 + 0u;
    float4 _628 = t0_space9[_625].SampleBias(_623, float2(_112, _113), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
    float _630 = saturate(_610);
    float _631 = 1.0f - _630;
    bool _632 = (_631 > 0.0f);
    bool _633 = (_631 < 0.0f);
    int _634 = (int)(uint)(_632);
    int _635 = (int)(uint)(_633);
    int _636 = _634 - _635;
    float _637 = float((int)(_636));
    float _638 = abs(_631);
    float _639 = _637 * _638;
    float _640 = _619 / _639;
    float _641 = saturate(_640);
    float _642 = _499 * 2.0f;
    float _643 = _642 + -1.0f;
    float _644 = saturate(_643);
    float _645 = _644 * _641;
    float _646 = _628.y + -0.550000011920929f;
    float _647 = _646 * 2.222222328186035f;
    float _648 = saturate(_647);
    float _649 = max(_645, _648);
    float _650 = 0.004024715628474951f - _604;
    float _651 = 0.004024715628474951f - _605;
    float _652 = 0.004024715628474951f - _606;
    float _653 = _649 * _650;
    float _654 = _649 * _651;
    float _655 = _649 * _652;
    float _656 = _653 + _604;
    float _657 = _654 + _605;
    float _658 = _655 + _606;
    _660 = _656;
    _661 = _657;
    _662 = _658;
  } else {
    _660 = 0.0f;
    _661 = 0.0f;
    _662 = 0.0f;
  }
  uint _666 = ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.StaticPerInstance_Constant_012 * STAGE_IO_5;
  uint _667 = (int)(ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.StaticPerInstance_Constant_000) + 3u;
  uint _668 = _667 + _666;
  float4 _670 = t0_space7.Load(_668);
  float _689 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].x) * _670.x;
  float _690 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].y), _670.y, _689);
  float _691 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].z), _670.z, _690);
  float _692 = _691 + (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[0].w);
  float _693 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].x) * _670.x;
  float _694 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].y), _670.y, _693);
  float _695 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].z), _670.z, _694);
  float _696 = _695 + (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[1].w);
  float _697 = (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[2].x) * _670.x;
  float _698 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[2].y), _670.y, _697);
  float _699 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[2].z), _670.z, _698);
  float _703 = _692 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.x;
  float _704 = _696 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.y;
  bool _710 = (_703 > cb0_space2_009x);
  bool _711 = (_704 > cb0_space2_009y);
  bool _712 = _710 && _711;
  bool _713 = (_703 < cb0_space2_009z);
  bool _714 = _713 && _712;
  bool _715 = (_704 < cb0_space2_009w);
  bool _716 = _715 && _714;
  if (_716) {
    SamplerState _719 = SamplerDescriptorHeap[2u];
    float _724 = _703 - cb0_space2_009x;
    float _725 = _704 - cb0_space2_009y;
    float _726 = cb0_space2_009z - cb0_space2_009x;
    float _727 = cb0_space2_009w - cb0_space2_009y;
    float _728 = _724 / _726;
    float _729 = _725 / _727;
    float _730 = 1.0f - _728;
    float _731 = 1.0f - _729;
    float4 _733 = t29_space2.SampleLevel(_719, float2(_730, _731), 0.0f);
    float _735 = max(_733.y, cb0_space2_011y);
    float _736 = min(_735, cb0_space2_010y);
    _738 = _736;
  } else {
    _738 = 0.0f;
  }
  bool _739 = (_738 > 0.0f);
  float _740 = select(_554, _660, _604);
  float _741 = select(_554, _661, _605);
  float _742 = select(_554, _662, _606);
  Texture2D<float3> _748 = ResourceDescriptorHeap[(int)(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_012)];
  float3 _749 = _748.SampleBias(_142, float2(STAGE_IO.x, STAGE_IO.y), Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_164, int2(0, 0));
  float _752 = _749.x * 2.0f;
  float _753 = _749.y * 2.0f;
  float _754 = _752 + -1.0f;
  float _755 = _753 + -1.0f;
  float _756 = dot(float2(_754, _755), float2(_754, _755));
  float _757 = 1.0f - _756;
  float _758 = saturate(_757);
  float _759 = sqrt(_758);
  float _762 = STAGE_IO_2.y * STAGE_IO_3.z;
  float _763 = STAGE_IO_2.z * STAGE_IO_3.y;
  float _764 = _762 - _763;
  float _765 = STAGE_IO_2.z * STAGE_IO_3.x;
  float _766 = STAGE_IO_2.x * STAGE_IO_3.z;
  float _767 = _765 - _766;
  float _768 = STAGE_IO_2.x * STAGE_IO_3.y;
  float _769 = STAGE_IO_2.y * STAGE_IO_3.x;
  float _770 = _768 - _769;
  bool _771 = (STAGE_IO_3.w > 0.25f);
  float _772 = select(_771, -1.0f, 1.0f);
  float _773 = _764 * _772;
  float _774 = _767 * _772;
  float _775 = _770 * _772;
  float _776 = dot(float3(_754, _755, _759), float3(_754, _755, _759));
  float _777 = rsqrt(_776);
  float _778 = _777 * _754;
  float _779 = _777 * _755;
  float _780 = _777 * _759;
  float _781 = _778 * STAGE_IO_3.x;
  float _782 = mad(_773, _779, _781);
  float _783 = mad(STAGE_IO_2.x, _780, _782);
  float _784 = _778 * STAGE_IO_3.y;
  float _785 = mad(_774, _779, _784);
  float _786 = mad(STAGE_IO_2.y, _780, _785);
  float _787 = _778 * STAGE_IO_3.z;
  float _788 = mad(_775, _779, _787);
  float _789 = mad(STAGE_IO_2.z, _780, _788);
  float _790 = dot(float3(_46, _47, _48), float3(_46, _47, _48));
  int _791 = asint(_790);
  uint _792 = _791 >> 1;
  int _793 = _792 + 532369198;
  float _794 = asfloat(_793);
  float _795 = dot(float3(_783, _786, _789), float3(_783, _786, _789));
  float _796 = rsqrt(_795);
  float _797 = _796 * _789;
  float _798 = SV_Position.w * -0.014705882407724857f;
  float _799 = _798 * Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_880;
  float _800 = -0.1764705926179886f - _799;
  float _801 = saturate(_800);
  float _802 = _794 + -100.0f;
  float _803 = _802 * 0.012500000186264515f;
  float _804 = saturate(_803);
  float _805 = _801 * 0.05000000074505806f;
  float _806 = 0.10000000149011612f - _805;
  float _807 = max(_804, 0.0f);
  float _808 = min(_807, 1.0f);
  float _809 = abs(_797);
  float _810 = Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_104 * 0.20000000298023224f;
  float _813 = _808 * _806;
  float _814 = _806 - _813;
  float _815 = SV_Position.w + -15.0f;
  float _816 = _815 * 0.015384615398943424f;
  float _817 = saturate(_816);
  float _818 = 1.0f - _817;
  float _819 = _810 * _818;
  float _820 = _819 + 0.20000000298023224f;
  float _821 = Scratch_PerFrame_000.Scratch_PerFrame_Constants_000.GlobalConstants_104 * 0.10600000619888306f;
  float _822 = _821 + 0.05000000074505806f;
  if (_739) {
    int _827 = asint(Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_928.GlobalRenderVariablesSRT_072);
    int _828 = _827 & 65535;
    float _829 = f16tof32(_828);
    int _830 = (uint)(_827) >> 16;
    float _831 = f16tof32(_830);
    int _832 = asint(Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_928.GlobalRenderVariablesSRT_076);
    int _833 = _832 & 65535;
    float _834 = f16tof32(_833);
    float _835 = _703 - _829;
    float _836 = _835 - Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.x;
    float _837 = _704 - _831;
    float _838 = _837 - Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_912.y;
    float _839 = _699 + (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_192[2].w);
    float _840 = _839 - _834;
    float _841 = dot(float3(_836, _838, _840), float3(_836, _838, _840));
    int _842 = asint(_841);
    uint _843 = _842 >> 1;
    int _844 = _843 + 532369198;
    float _845 = asfloat(_844);
    float _846 = _845 + -120.0f;
    float _847 = _846 * -0.01666666753590107f;
    float _848 = saturate(_847);
    float _849 = max(_848, Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_928.GlobalRenderVariablesSRT_052);
    float _850 = _738 * 2.0f;
    float _851 = _850 * _849;
    float _852 = _851 * _851;
    float _853 = _852 * _852;
    float _854 = _853 * _851;
    float _855 = max(_854, 0.0f);
    float _856 = min(_855, 1.0f);
    float _857 = _856 * _819;
    float _858 = _820 - _857;
    float _859 = 0.005155667196959257f - _740;
    float _860 = 0.005155667196959257f - _741;
    float _861 = 0.005155667196959257f - _742;
    float _862 = _856 * _859;
    float _863 = _856 * _860;
    float _864 = _856 * _861;
    float _865 = _862 + _740;
    float _866 = _863 + _741;
    float _867 = _864 + _742;
    float _868 = 0.10400000214576721f - _821;
    float _869 = _856 * _868;
    float _870 = _869 + _822;
    float _871 = _856 * _814;
    float _872 = _814 - _871;
    _874 = _872;
    _875 = _858;
    _876 = _870;
    _877 = _865;
    _878 = _866;
    _879 = _867;
  } else {
    _874 = _814;
    _875 = _820;
    _876 = _822;
    _877 = _740;
    _878 = _741;
    _879 = _742;
  }
  float _885 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.x * SV_Position.x;
  float _886 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.y * SV_Position.y;
  float _887 = _886 + Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.w;
  float _888 = STAGE_IO_4.x / STAGE_IO_4.w;
  float _889 = STAGE_IO_4.y / STAGE_IO_4.w;
  float _890 = Scratch_PerView_000.Scratch_PerView_Constants_000.ViewConstants_784.z - _888;
  float _891 = _890 + _885;
  float _892 = _887 - _889;
  float _893 = _809 * 8.0f;
  float _894 = _893 + 8.000100135803223f;
  float _895 = sqrt(_894);
  float _896 = 1.0f / _895;
  float _897 = _896 * _796;
  float _898 = _897 * _783;
  float _899 = _897 * _786;
  float _900 = _898 + 0.5f;
  float _901 = _899 + 0.5f;
  float _902 = saturate(_874);
  float _903 = saturate(ShaderInstance_PerBatch_000.ShaderInstance_PerBatch_Constants_000.StaticPerBatch_Constant_032);
  float _904 = _903 * 247.0f;
  uint _905 = uint(_904);
  uint _906 = _905 << 5;
  int _907 = _906 & 128;
  int _908 = (uint)(_905) >> 5;
  int _909 = _908 & 4;
  int _910 = _905 & 16777083;
  int _911 = _909 | _910;
  int _912 = _911 | _907;
  float _913 = _902 * 255.0f;
  uint _914 = uint(_913);
  uint _915 = _912 << 8;
  int _916 = _915 | _914;
  float _917 = f16tof32(_916);
  int _920 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_256.x & 7;
  bool _921 = (_920 == 7);
  if (!_921) {
    int _923 = Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_256.x & 8;
    bool _924 = (_923 != 0);
    float _925 = select(_924, 0.2039215862751007f, 0.3921568989753723f);
    _927 = _925;
  } else {
    _927 = 0.01568627543747425f;
  }
  SV_Target.x = _877;
  SV_Target.y = _878;
  SV_Target.z = _879;
  SV_Target.w = 1.0f;
  SV_Target_2.x = _900;
  SV_Target_2.y = _901;
  SV_Target_3.x = _875;
  SV_Target_3.y = _917;
  SV_Target_4.x = _876;
  SV_Target_4.y = _876;
  SV_Target_4.z = _876;
  SV_Target_4.w = _927;
  SV_Target_5.x = _891;
  SV_Target_5.y = _892;
  OutputSignature output_signature = { SV_Target, SV_Target_2, SV_Target_3, SV_Target_4, SV_Target_5 };
  return output_signature;
}
