struct InUniform_Constant {
  float4 InUniform_Constant_000[4];
  float InUniform_Constant_064;
};

struct ShaderInstance_PerInstance_Constants {
  InUniform_Constant ShaderInstance_PerInstance_Constants_000;
};


Buffer<float4> t0_space8 : register(t0, space8);

cbuffer cb0_space8 : register(b0, space8) {
  ShaderInstance_PerInstance_Constants ShaderInstance_PerInstance_000 : packoffset(c000.x);
};

float4 main(
  float4 POSITION : POSITION,
  uint4 BLENDINDICES : BLENDINDICES
) : SV_Position {
  float4 SV_Position;
  uint _30 = BLENDINDICES.x * 6;
  float4 _32 = t0_space8.Load(_30);
  int _37 = _30 | 1;
  float4 _38 = t0_space8.Load(_37);
  uint _43 = _30 + 2u;
  float4 _44 = t0_space8.Load(_43);
  float _49 = _32.x * POSITION.x;
  float _50 = mad(_32.y, POSITION.y, _49);
  float _51 = mad(_32.z, POSITION.z, _50);
  float _52 = _51 + _32.w;
  float _53 = _38.x * POSITION.x;
  float _54 = mad(_38.y, POSITION.y, _53);
  float _55 = mad(_38.z, POSITION.z, _54);
  float _56 = _55 + _38.w;
  float _57 = _44.x * POSITION.x;
  float _58 = mad(_44.y, POSITION.y, _57);
  float _59 = mad(_44.z, POSITION.z, _58);
  float _60 = _59 + _44.w;
  float _61 = _52 * (ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[0].x);
  float _62 = mad((ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[1].x), _56, _61);
  float _63 = mad((ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[2].x), _60, _62);
  float _64 = _63 + (ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[3].x);
  float _65 = _52 * (ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[0].y);
  float _66 = mad((ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[1].y), _56, _65);
  float _67 = mad((ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[2].y), _60, _66);
  float _68 = _67 + (ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[3].y);
  float _69 = _52 * (ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[0].z);
  float _70 = mad((ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[1].z), _56, _69);
  float _71 = mad((ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[2].z), _60, _70);
  float _72 = _71 + (ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[3].z);
  float _73 = _52 * (ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[0].w);
  float _74 = mad((ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[1].w), _56, _73);
  float _75 = mad((ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[2].w), _60, _74);
  float _76 = _75 + (ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_000[3].w);
  bool _77 = (ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064 == 0.0f);
  float _90;
  float _91;
  if (!_77) {
    float _79 = abs(_64);
    float _80 = abs(_68);
    float _81 = log2(_79);
    float _82 = log2(_80);
    float _83 = _81 * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064;
    float _84 = _82 * ShaderInstance_PerInstance_000.ShaderInstance_PerInstance_Constants_000.InUniform_Constant_064;
    float _85 = exp2(_83);
    float _86 = exp2(_84);
    float _87 = _85 * _64;
    float _88 = _86 * _68;
    _90 = _87;
    _91 = _88;
  } else {
    _90 = _64;
    _91 = _68;
  }
  SV_Position.x = _90;
  SV_Position.y = _91;
  SV_Position.z = _72;
  SV_Position.w = _76;
  return SV_Position;
}
