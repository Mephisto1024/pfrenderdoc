struct RasterizerVariables {
  float4 RasterizerVariables_000[4];
  float4 RasterizerVariables_064[4];
  float4 RasterizerVariables_128[4];
  float4 RasterizerVariables_192[3];
  int4 RasterizerVariables_240;
  int4 RasterizerVariables_256;
};

struct Scratch_PerInstance_Constants {
  RasterizerVariables Scratch_PerInstance_Constants_000;
};


Texture2D<float4> t0_space5 : register(t0, space5);

Texture2D<float4> t1_space5 : register(t1, space5);

cbuffer cb0_space5 : register(b0, space5) {
  struct Scratch_PerBatch_Constants {
    struct CloudPrePassParams_Constant {
      float4 CloudPrePassParams_Constant_000;
      float3 CloudPrePassParams_Constant_016;
      float CloudPrePassParams_Constant_028;
      float2 CloudPrePassParams_Constant_032;
      float CloudPrePassParams_Constant_040;
      float CloudPrePassParams_Constant_044;
      int CloudPrePassParams_Constant_048;
      float CloudPrePassParams_Constant_052;
      int CloudPrePassParams_Constant_056;
      float CloudPrePassParams_Constant_060;
      float CloudPrePassParams_Constant_064;
      int CloudPrePassParams_Constant_068;
      int CloudPrePassParams_Constant_072;
      float CloudPrePassParams_Constant_076;
    } Scratch_PerBatch_Constants_000;
  } Scratch_PerBatch_000 : packoffset(c000.x);
};

cbuffer cb0_space6 : register(b0, space6) {
  Scratch_PerInstance_Constants Scratch_PerInstance_000 : packoffset(c000.x);
};

SamplerState s0_space5 : register(s0, space5);

struct OutputSignature {
  noperspective float4 SV_Position : SV_Position;
  linear float LINEAR_DEPTH : LINEAR_DEPTH;
};

OutputSignature main(
  uint SV_VertexID : SV_VertexID
) {
  float4 SV_Position;
  float LINEAR_DEPTH;
  int _62 = Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_048 + 1;
  uint _63 = SV_VertexID % _62;
  float _64 = float((uint)_63);
  float _65 = _64 * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_052;
  float _66 = _65 + Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_028;
  int _67 = SV_VertexID / _62;
  float _68 = float((uint)_67);
  float _69 = _68 * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_052;
  float _70 = _69 + Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_044;
  float _84;
  float _85;
  float _124;
  switch ((int)(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_068)) {
    case 1: {
      _84 = Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_028;
      _85 = _70;
      break;
    }
    case 2: {
      float _73 = float((int)(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_048));
      float _74 = _73 * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_052;
      float _75 = _74 + Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_028;
      _84 = _75;
      _85 = _70;
      break;
    }
    case 4: {
      float _77 = _69 + Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_028;
      _84 = _77;
      _85 = Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_044;
      break;
    }
    case 8: {
      float _79 = _69 + Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_028;
      float _80 = float((int)(Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_048));
      float _81 = _80 * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_052;
      float _82 = _81 + Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_044;
      _84 = _79;
      _85 = _82;
      break;
    }
    default: {
      _84 = _66;
      _85 = _70;
      break;
    }
  }
  float _86 = _84 * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_000.x;
  float _87 = _85 * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_000.y;
  float _88 = _86 + Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_000.z;
  float _89 = _87 + Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_000.w;
  float4 _92 = t0_space5.SampleLevel(s0_space5, float2(_88, _89), 0.0f);
  float _95 = _92.x + -0.019999999552965164f;
  float _96 = _95 * 1792.0f;
  float _97 = _96 + 435.20001220703125f;
  float _98 = _92.y * 1792.0f;
  float _99 = _98 + 435.20001220703125f;
  float4 _101 = t1_space5.SampleLevel(s0_space5, float2(_88, _89), 0.0f);
  bool _103 = (_101.w == 0.0f);
  if (_103) {
    float _105 = Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_040 * 60.0f;
    float _106 = _105 * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_032.x;
    float _107 = _84 - _106;
    float _108 = _107 * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_000.x;
    float _109 = _108 + Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_000.z;
    float _110 = _105 * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_032.y;
    float _111 = _85 - _110;
    float _112 = _111 * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_000.y;
    float _113 = _112 + Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_000.w;
    float4 _114 = t1_space5.SampleLevel(s0_space5, float2(_109, _113), 0.0f);
    float _117 = max(_101.y, _114.y);
    float _118 = saturate(_117);
    float _119 = log2(_118);
    float _120 = _119 * 0.10000000149011612f;
    float _121 = exp2(_120);
    float _122 = max(0.20000000298023224f, _121);
    _124 = _122;
  } else {
    _124 = 1.0f;
  }
  float _125 = _99 - _97;
  float _126 = _124 * _125;
  float _127 = _126 + _97;
  float _128 = _84 - Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_016.x;
  float _129 = _85 - Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_016.y;
  float _130 = _128 * _128;
  float _131 = _129 * _129;
  float _132 = _131 + _130;
  float _133 = sqrt(_132);
  float _134 = _133 / Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_064;
  float _135 = _134 * _134;
  float _136 = _135 * Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_064;
  float _137 = _127 - _136;
  float _138 = _97 - _136;
  bool _139 = (Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_056 != 0);
  float _140 = select(_139, _138, _137);
  bool _141 = (Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_068 == 0);
  bool _142 = (_63 == 0);
  float _143 = select(_142, _138, _137);
  float _144 = select(_141, _140, _143);
  bool _145 = (Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_072 != 0);
  float _146 = Scratch_PerBatch_000.Scratch_PerBatch_Constants_000.CloudPrePassParams_Constant_076 - _144;
  float _147 = select(_145, _146, _144);
  float _148 = _84 * (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_064[0].z);
  float _149 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_064[1].z), _85, _148);
  float _150 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_064[2].z), _147, _149);
  float _151 = _150 + (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_064[3].z);
  float _152 = abs(_151);
  LINEAR_DEPTH = _152;
  float _153 = _84 * (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[0].x);
  float _154 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[1].x), _85, _153);
  float _155 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[2].x), _147, _154);
  float _156 = _155 + (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[3].x);
  float _157 = _84 * (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[0].y);
  float _158 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[1].y), _85, _157);
  float _159 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[2].y), _147, _158);
  float _160 = _159 + (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[3].y);
  float _161 = _84 * (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[0].z);
  float _162 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[1].z), _85, _161);
  float _163 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[2].z), _147, _162);
  float _164 = _163 + (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[3].z);
  float _165 = _84 * (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[0].w);
  float _166 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[1].w), _85, _165);
  float _167 = mad((Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[2].w), _147, _166);
  float _168 = _167 + (Scratch_PerInstance_000.Scratch_PerInstance_Constants_000.RasterizerVariables_000[3].w);
  SV_Position.x = _156;
  SV_Position.y = _160;
  SV_Position.z = _164;
  SV_Position.w = _168;
  OutputSignature output_signature = { SV_Position, LINEAR_DEPTH };
  return output_signature;
}
