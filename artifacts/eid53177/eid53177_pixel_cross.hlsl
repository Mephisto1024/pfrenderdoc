cbuffer _21_23 : register(b0, space1)
{
    float4 _23_m0[24] : packoffset(c0);
};

cbuffer _26_28 : register(b0, space3)
{
    float4 _28_m0[75] : packoffset(c0);
};

cbuffer _31_33 : register(b0, space6)
{
    float4 _33_m0[37] : packoffset(c0);
};

cbuffer _36_38 : register(b0, space7)
{
    float4 _38_m0[1] : packoffset(c0);
};

cbuffer _41_43 : register(b0, space8)
{
    float4 _43_m0[4] : packoffset(c0);
};

SamplerState _8[] : register(s0, space0);
Texture2D<float4> _13[] : register(t0, space0);
Buffer<float4> _16 : register(t0, space7);

static float4 gl_FragCoord;
static float2 STAGE_IO;
static float3 STAGE_IO_1;
static float4 STAGE_IO_2;
static float4 STAGE_IO_3;
static uint STAGE_IO_4;
static float4 SV_Target;
static float4 SV_Target_1;
static float2 SV_Target_2;
static float2 SV_Target_3;
static float4 SV_Target_4;
static float2 SV_Target_5;

struct SPIRV_Cross_Input
{
    float2 STAGE_IO : TEXCOORD0;
    float3 STAGE_IO_1 : TEXCOORD1;
    float4 STAGE_IO_2 : TEXCOORD2;
    float4 STAGE_IO_3 : TEXCOORD3;
    nointerpolation uint STAGE_IO_4 : TEXCOORD4;
    float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
    float4 SV_Target_1 : SV_Target1;
    float2 SV_Target_2 : SV_Target2;
    float2 SV_Target_3 : SV_Target3;
    float4 SV_Target_4 : SV_Target4;
    float2 SV_Target_5 : SV_Target5;
};

static bool discard_state;

uint spvPackHalf2x16(float2 value)
{
    uint2 Packed = f32tof16(value);
    return Packed.x | (Packed.y << 16);
}

float2 spvUnpackHalf2x16(uint value)
{
    return f16tof32(uint2(value & 0xffff, value >> 16));
}

void discard_exit()
{
    if (discard_state)
    {
        discard;
    }
}

void frag_main()
{
    discard_state = false;
    float _110 = (STAGE_IO.x * 2.0f) + (-1.0f);
    float _112 = (STAGE_IO.y * 2.0f) + (-1.0f);
    float _120 = atan(_110 / _112);
    bool _126 = _112 < 0.0f;
    bool _128 = _112 == 0.0f;
    bool _129 = _110 >= 0.0f;
    bool _130 = _110 < 0.0f;
    float _148 = (((_129 && _128) ? 0.75f : ((_130 && _128) ? 0.25f : ((((_130 && _126) ? (_120 + (-3.1415927410125732421875f)) : ((_129 && _126) ? (_120 + 3.1415927410125732421875f) : _120)) * 0.15915493667125701904296875f) + 0.5f))) + (_23_m0[6u].w * 0.20000000298023223876953125f)) * 25.1327419281005859375f;
    uint4 _155 = asuint(_43_m0[0u]);
    uint4 _159 = asuint(_43_m0[1u]);
    uint _160 = _159.w;
    uint _164 = (_155.w * STAGE_IO_4) + _155.z;
    float4 _167 = _16.Load(_164 + (_160 >> 2u));
    float _106[4];
    _106[0u] = _167.x;
    _106[1u] = _167.y;
    _106[2u] = _167.z;
    _106[3u] = _167.w;
    float _183 = _106[_160 & 3u] * 0.0500000007450580596923828125f;
    float _185 = _183 * (cos(_148) + 1.0f);
    float _186 = _183 * (sin(_148) + 1.0f);
    float _187 = _186 + _110;
    float _188 = _186 + _112;
    float _189 = _185 + _110;
    float _190 = _185 + _112;
    uint _191 = _159.z;
    float4 _194 = _16.Load(_164 + (_191 >> 2u));
    float _105[4];
    _105[0u] = _194.x;
    _105[1u] = _194.y;
    _105[2u] = _194.z;
    _105[3u] = _194.w;
    float _214 = clamp(sqrt((_189 * _189) + (_190 * _190)), 0.0f, 1.0f);
    float _220 = clamp(sqrt((_187 * _187) + (_188 * _188)), 0.0f, 1.0f);
    uint _225 = _159.y;
    float4 _228 = _16.Load(_164 + (_225 >> 2u));
    float _104[4];
    _104[0u] = _228.x;
    _104[1u] = _228.y;
    _104[2u] = _228.z;
    _104[3u] = _228.w;
    uint4 _249 = asuint(_43_m0[2u]);
    uint _250 = _249.x;
    float4 _253 = _16.Load((_250 >> 2u) + _164);
    float _103[4];
    _103[0u] = _253.x;
    _103[1u] = _253.y;
    _103[2u] = _253.z;
    _103[3u] = _253.w;
    float _265 = _104[_225 & 3u] * _23_m0[6u].w;
    float _269 = (-0.0f) - min(max(_105[_191 & 3u] * 2.0f, 0.0f), 2.0f);
    float _271 = _103[_250 & 3u] * 2.0f;
    float _274 = frac(_265);
    float _275 = _110 * _269;
    float _276 = frac(_265 + 0.5f) * (1.0f - (clamp((_214 * _214) * (3.0f - (_214 * 2.0f)), 0.0f, 1.0f) * 0.980000019073486328125f));
    float _278 = _112 * _269;
    float _280 = _271 * STAGE_IO.x;
    float _281 = _271 * STAGE_IO.y;
    float _282 = _274 * (1.0f - (clamp((_220 * _220) * (3.0f - (_220 * 2.0f)), 0.0f, 1.0f) * 0.980000019073486328125f));
    float _293 = abs((_274 * 2.0f) + (-1.0f));
    uint _305 = asuint(_38_m0[0u]).x;
    float4 _311 = _13[_305].SampleBias(_8[116u], float2((_282 * _275) + _280, (_282 * _278) + _281), _23_m0[10u].y);
    float _313 = _311.x;
    float _314 = _311.y;
    float _315 = _311.z;
    float4 _316 = _13[_305].SampleBias(_8[116u], float2(((_276 * _275) + 0.5f) + _280, ((_276 * _278) + 0.5f) + _281), _23_m0[10u].y);
    float _332 = sqrt((_112 * _112) + (_110 * _110));
    float _333 = _332 + (-1.0f);
    float _336 = clamp(_333 * (-3.3333332538604736328125f), 0.0f, 1.0f);
    uint4 _343 = asuint(_43_m0[0u]);
    uint4 _347 = asuint(_43_m0[2u]);
    uint _348 = _347.z;
    float4 _355 = _16.Load(((_343.w * STAGE_IO_4) + _343.z) + (_348 >> 2u));
    float _100[4];
    _100[0u] = _355.x;
    _100[1u] = _355.y;
    _100[2u] = _355.z;
    _100[3u] = _355.w;
    uint _367 = asuint(_100[_348 & 3u]);
    float _381 = clamp(_333 * (-2.0f), 0.0f, 1.0f);
    uint _410 = uint(int((_28_m0[45u].x * gl_FragCoord.x) + _28_m0[45u].z));
    uint _411 = uint(int((_28_m0[45u].y * gl_FragCoord.y) + _28_m0[45u].w));
    uint _416 = ((_410 << 8u) ^ _410) & 16711935u;
    uint _418 = ((_411 << 8u) ^ _411) & 16711935u;
    uint _423 = ((_416 << 4u) | _416) & 252645135u;
    uint _425 = ((_418 << 4u) | _418) & 252645135u;
    uint _430 = ((_423 << 2u) | _423) & 858993459u;
    uint _432 = ((_425 << 2u) | _425) & 858993459u;
    uint _437 = ((_430 << 1u) | _430) & 1431655765u;
    if ((clamp(((((-0.0f) - _315) - ((_316.z - _315) * _293)) + ((_336 * _336) * (3.0f - (_336 * 2.0f)))) * 2.0f, 0.0f, 1.0f) == 0.0f) || ((float(reversebits((_437 ^ (((_432 << 1u) | _432) & 1431655765u)) | (_437 << 1u)) >> 26u) * 0.015625f) >= ((((_381 * _381) * 0.0039215688593685626983642578125f) * float(_367 >> 24u)) * (3.0f - (_381 * 2.0f)))))
    {
        discard_state = true;
    }
    uint4 _457 = asuint(_43_m0[0u]);
    uint4 _461 = asuint(_43_m0[2u]);
    uint _462 = _461.y;
    uint _466 = (_457.w * STAGE_IO_4) + _457.z;
    float4 _469 = _16.Load(_466 + (_462 >> 2u));
    float _99[4];
    _99[0u] = _469.x;
    _99[1u] = _469.y;
    _99[2u] = _469.z;
    _99[3u] = _469.w;
    float _490 = 1.0f - clamp((_332 + (-0.25f)) * 1.33333337306976318359375f, 0.0f, 1.0f);
    float _500 = (_490 * _490) * (_99[_462 & 3u] * 2.0f);
    float _501 = _500 * (((((_316.x - _313) * _293) + _313) * 2.0f) + (-1.0f));
    float _502 = _500 * (((((_316.y - _314) * _293) + _314) * 2.0f) + (-1.0f));
    float _515 = (STAGE_IO_2.w > 0.25f) ? (-1.0f) : 1.0f;
    float _523 = mad(((STAGE_IO_1.y * STAGE_IO_2.z) - (STAGE_IO_1.z * STAGE_IO_2.y)) * _515, _502, _501 * STAGE_IO_2.x) + STAGE_IO_1.x;
    float _526 = mad(((STAGE_IO_1.z * STAGE_IO_2.x) - (STAGE_IO_1.x * STAGE_IO_2.z)) * _515, _502, _501 * STAGE_IO_2.y) + STAGE_IO_1.y;
    float _529 = mad(((STAGE_IO_1.x * STAGE_IO_2.y) - (STAGE_IO_1.y * STAGE_IO_2.x)) * _515, _502, _501 * STAGE_IO_2.z) + STAGE_IO_1.z;
    float _534 = rsqrt(dot(float3(_523, _526, _529), float3(_523, _526, _529)));
    float _535 = _534 * _523;
    float _536 = _534 * _526;
    float _537 = _534 * _529;
    uint4 _540 = asuint(_43_m0[3u]);
    uint _541 = _540.x;
    float4 _544 = _16.Load((_541 >> 2u) + _466);
    float _101[4];
    _101[0u] = _544.x;
    _101[1u] = _544.y;
    _101[2u] = _544.z;
    _101[3u] = _544.w;
    uint _553 = _541 & 3u;
    uint _556 = _461.w;
    float4 _559 = _16.Load(_466 + (_556 >> 2u));
    float _102[4];
    _102[0u] = _559.x;
    _102[1u] = _559.y;
    _102[2u] = _559.z;
    _102[3u] = _559.w;
    float _577 = rsqrt(dot(float3(_535, _536, _537), float3(_535, _536, _537)));
    uint4 _583 = asuint(_33_m0[16u]);
    uint _584 = _583.x;
    float _588;
    if ((_584 & 7u) == 7u)
    {
        _588 = 0.0f;
    }
    else
    {
        _588 = ((_584 & 8u) != 0u) ? 0.1882353127002716064453125f : 0.376470625400543212890625f;
    }
    float _597 = (1.0f / sqrt(((_537 * 8.0f) * _577) + 8.00010013580322265625f)) * _577;
    SV_Target.x = float((_367 >> 16u) & 255u) * 0.0039215688593685626983642578125f;
    SV_Target.y = float((_367 >> 8u) & 255u) * 0.0039215688593685626983642578125f;
    SV_Target.z = float(_367 & 255u) * 0.0039215688593685626983642578125f;
    SV_Target.w = 1.0f;
    SV_Target_1.x = 0.0f;
    SV_Target_1.y = 0.0f;
    SV_Target_1.z = 0.0f;
    SV_Target_1.w = 0.0f;
    SV_Target_2.x = (_597 * _535) + 0.5f;
    SV_Target_2.y = (_597 * _536) + 0.5f;
    SV_Target_3.x = _102[_556 & 3u];
    SV_Target_3.y = spvUnpackHalf2x16(25088u).x;
    SV_Target_4.x = _101[_553];
    SV_Target_4.y = _101[_553];
    SV_Target_4.z = _101[_553];
    SV_Target_4.w = _588;
    SV_Target_5.x = (_28_m0[49u].z - (STAGE_IO_3.x / STAGE_IO_3.w)) + (_28_m0[49u].x * gl_FragCoord.x);
    SV_Target_5.y = ((_28_m0[49u].y * gl_FragCoord.y) + _28_m0[49u].w) - (STAGE_IO_3.y / STAGE_IO_3.w);
    discard_exit();
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_FragCoord = stage_input.gl_FragCoord;
    gl_FragCoord.w = 1.0 / gl_FragCoord.w;
    STAGE_IO = stage_input.STAGE_IO;
    STAGE_IO_1 = stage_input.STAGE_IO_1;
    STAGE_IO_2 = stage_input.STAGE_IO_2;
    STAGE_IO_3 = stage_input.STAGE_IO_3;
    STAGE_IO_4 = stage_input.STAGE_IO_4;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    stage_output.SV_Target_1 = SV_Target_1;
    stage_output.SV_Target_2 = SV_Target_2;
    stage_output.SV_Target_3 = SV_Target_3;
    stage_output.SV_Target_4 = SV_Target_4;
    stage_output.SV_Target_5 = SV_Target_5;
    return stage_output;
}
