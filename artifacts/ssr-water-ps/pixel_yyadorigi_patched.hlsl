// EID 9236; corrected TEXCOORD semantics to match captured pixel shader input.
cbuffer CB0UBO : register(b0)
{
    float4 CB0_m0[14] : packoffset(c0);
};

cbuffer CB1UBO : register(b1)
{
    float4 CB1_m0[7] : packoffset(c0);
};

cbuffer CB2UBO : register(b2)
{
    float4 CB2_m0[21] : packoffset(c0);
};

Texture2D<float4> T0 : register(t0);
Texture2D<float4> T1 : register(t1);
Texture2D<float4> T2 : register(t2);
Texture2D<float4> T3 : register(t3);
Texture2D<float4> T4 : register(t4);
SamplerState S0 : register(s0);
SamplerState S1 : register(s1);

static float4 TEXCOORD;
static float4 TEXCOORD_1;
static float4 TEXCOORD_2;
static float4 TEXCOORD_3;
static float4 SV_Target;
static float4 SV_Target_1;
static float4 SV_Target_2;

struct SPIRV_Cross_Input
{
    float4 TEXCOORD : TEXCOORD0;
    float4 TEXCOORD_1 : TEXCOORD1;
    float4 TEXCOORD_2 : TEXCOORD2;
    float4 TEXCOORD_3 : TEXCOORD3;
};

struct SPIRV_Cross_Output
{
    float4 SV_Target : SV_Target0;
    float4 SV_Target_1 : SV_Target1;
    float4 SV_Target_2 : SV_Target2;
};

uint2 spvTextureSize(Texture2D<float4> Tex, uint Level, out uint Param)
{
    uint2 ret;
    Tex.GetDimensions(Level, ret.x, ret.y, Param);
    return ret;
}

void frag_main()
{
    float _61 = TEXCOORD_2.x / TEXCOORD_2.w;
    float _62 = TEXCOORD_2.y / TEXCOORD_2.w;
    SV_Target_2.x = asfloat(asuint(mad((-0.0f) - TEXCOORD_2.w, CB1_m0[6u].w, 1.0f)) & ((0.5f < CB0_m0[2u].z) ? 4294967295u : 0u));
    float _104 = ((-0.0f) - TEXCOORD.x) + CB1_m0[5u].x;
    float _105 = ((-0.0f) - TEXCOORD.y) + CB1_m0[5u].y;
    float _106 = ((-0.0f) - TEXCOORD.z) + CB1_m0[5u].z;
    float _111 = rsqrt(dot(float3(_104, _105, _106), float3(_104, _105, _106)));
    float _112 = _111 * _104;
    float _113 = _111 * _105;
    float _114 = _111 * _106;
    float _124 = dot(float3((-0.0f) - _112, (-0.0f) - _113, (-0.0f) - _114), float3(TEXCOORD_1.x, TEXCOORD_1.y, TEXCOORD_1.z));
    float _134 = (-0.0f) - (_124 + _124);
    float _138 = mad(TEXCOORD_1.x, _134, (-0.0f) - _112);
    float _139 = mad(TEXCOORD_1.y, _134, (-0.0f) - _113);
    float _140 = mad(TEXCOORD_1.z, _134, (-0.0f) - _114);
    float _144 = rsqrt(dot(float3(_138, _139, _140), float3(_138, _139, _140)));
    float _145 = _144 * _138;
    float _146 = _144 * _139;
    float _147 = _144 * _140;
    uint _149;
    spvTextureSize(T2, 0u, _149);
    float _181 = mad(CB2_m0[11u].x, _147, mad(CB2_m0[9u].x, _145, _146 * CB2_m0[10u].x));
    float _182 = mad(CB2_m0[11u].y, _147, mad(CB2_m0[9u].y, _145, _146 * CB2_m0[10u].y));
    float _183 = mad(CB2_m0[11u].z, _147, mad(CB2_m0[9u].z, _145, _146 * CB2_m0[10u].z));
    float _188 = rsqrt(dot(float3(_181, _182, _183), float3(_181, _182, _183))) * _183;
    float _197 = asfloat((_188 == 0.0f) ? 1107296256u : asuint(TEXCOORD.w / _188));
    float _204 = asfloat((_197 < 0.0f) ? asuint(min((-0.0f) - _197, 32.0f)) : 1107296256u);
    float _211 = mad(_145, _204, TEXCOORD.x);
    float _212 = mad(_146, _204, TEXCOORD.y);
    float _213 = mad(_147, _204, TEXCOORD.z);
    float _263 = mad(CB2_m0[19u].w, TEXCOORD.z, mad(CB2_m0[17u].w, TEXCOORD.x, TEXCOORD.y * CB2_m0[18u].w)) + CB2_m0[20u].w;
    float _303 = mad(CB2_m0[19u].w, _213, mad(CB2_m0[17u].w, _211, _212 * CB2_m0[18u].w)) + CB2_m0[20u].w;
    float _306 = asfloat(1056964608u);
    float _312 = asfloat(asuint(CB1_m0[6u]).x);
    float _315 = _263 * _306;
    float _321 = _303 * _306;
    float _325 = 1.0f / _263;
    float _326 = 1.0f / _303;
    float _336 = _325 * (_315 + ((mad(CB2_m0[19u].x, TEXCOORD.z, mad(CB2_m0[17u].x, TEXCOORD.x, TEXCOORD.y * CB2_m0[18u].x)) + CB2_m0[20u].x) * _306));
    float _337 = _325 * (_315 + (((mad(CB2_m0[19u].y, TEXCOORD.z, mad(CB2_m0[17u].y, TEXCOORD.x, TEXCOORD.y * CB2_m0[18u].y)) + CB2_m0[20u].y) * _312) * 0.5f));
    float _338 = _325 * (mad(CB2_m0[19u].z, TEXCOORD.z, mad(CB2_m0[17u].z, TEXCOORD.x, TEXCOORD.y * CB2_m0[18u].z)) + CB2_m0[20u].z);
    float _339 = _326 * (_321 + ((mad(CB2_m0[19u].x, _213, mad(CB2_m0[17u].x, _211, _212 * CB2_m0[18u].x)) + CB2_m0[20u].x) * asfloat(1056964608u)));
    float _340 = _326 * (_321 + (((mad(CB2_m0[19u].y, _213, mad(CB2_m0[17u].y, _211, _212 * CB2_m0[18u].y)) + CB2_m0[20u].y) * _312) * 0.5f));
    float _342 = float(uint(CB0_m0[8u].x));
    float _343 = float(uint(CB0_m0[8u].y));
    float _344 = _342 * _336;
    float _345 = _343 * _337;
    float _357 = mad(_339, _342, asfloat((((_342 * _339) == _344) ? 4294967295u : 0u) & 981668463u));
    float _358 = mad(_340, _343, asfloat((((_343 * _340) == _345) ? 4294967295u : 0u) & 981668463u));
    float _361 = mad((-0.0f) - _336, _342, _357);
    float _362 = mad((-0.0f) - _337, _343, _358);
    float _368 = 1.0f / sqrt(dot(float2(_361, _362), float2(_361, _362)));
    float _375 = _368 * mad(_211, _326, (-0.0f) - (_325 * TEXCOORD.x));
    float _376 = _368 * mad(_212, _326, (-0.0f) - (_325 * TEXCOORD.y));
    float _377 = _368 * mad(_213, _326, (-0.0f) - (_325 * TEXCOORD.z));
    float _379 = ((-0.0f) - _325) + _326;
    float _380 = _368 * _379;
    float _384 = _357 + ((-0.0f) - _344);
    float _385 = _358 + ((-0.0f) - _345);
    float _386 = (_326 * (mad(CB2_m0[19u].z, _213, mad(CB2_m0[17u].z, _211, _212 * CB2_m0[18u].z)) + CB2_m0[20u].z)) + ((-0.0f) - _338);
    float _387 = _368 * _384;
    float _388 = _368 * _385;
    float _389 = _368 * _386;
    float _392 = mad(_386, _368, _338);
    uint _404 = min((_149 + 4294967295u), 6u);
    float _407 = max(_343 * 0.0625f, 1.0f);
    bool _408 = 0.0f < _387;
    bool _409 = 0.0f < _388;
    float _410 = _389 * (-2.0f);
    uint _412 = asuint(mad(TEXCOORD.x, _325, _375));
    uint _413 = asuint(mad(TEXCOORD.y, _325, _376));
    uint _414 = asuint(mad(TEXCOORD.z, _325, _377));
    uint _415 = asuint(mad(_384, _368, _344));
    uint _416 = asuint(mad(_385, _368, _345));
    uint _417 = asuint(mad(_379, _368, _325));
    uint _419;
    uint _435;
    uint _421;
    uint _423;
    uint _425;
    float _431;
    uint _433;
    uint _437;
    uint _439;
    uint _446;
    uint _447;
    uint _448;
    uint _449;
    uint _450;
    uint _453;
    uint _456;
    uint _457;
    float _739;
    float _740;
    uint _418 = 0u;
    uint _420 = _412;
    uint _422 = _413;
    uint _424 = _414;
    uint _426 = _415;
    uint _428 = _416;
    float _430 = _392;
    uint _432 = _417;
    uint _434 = 0u;
    uint _436 = _404;
    uint _438 = 0u;
    for (;;)
    {
        if ((((int(_436) < int(_149)) ? 4294967295u : 0u) & ((int(_436) >= int(0u)) ? 4294967295u : 0u)) == 0u)
        {
            _446 = _418;
            _447 = _420;
            _448 = _422;
            _449 = _424;
            _450 = _426;
            _453 = _428;
            _456 = _432;
            _457 = _438;
            break;
        }
        else
        {
            float _579 = float(1u << (_436 & 31u));
            float _582 = asfloat(_426) / _579;
            float _583 = asfloat(_428) / _579;
            float _610 = mad(_579, 0.0500000007450580596923828125f, min(mad(asfloat(_409 ? asuint(ceil(_583)) : asuint(floor(_583))), _579, (-0.0f) - asfloat(_428)) / _388, mad(asfloat(_408 ? asuint(ceil(_582)) : asuint(floor(_582))), _579, (-0.0f) - asfloat(_426)) / _387));
            float _614 = mad(_387, _610, asfloat(_426));
            float _615 = mad(_388, _610, asfloat(_428));
            float _616 = mad(_389, _610, _430);
            float _620 = mad(_375, _610, asfloat(_420));
            uint _621 = asuint(_620);
            float _622 = mad(_376, _610, asfloat(_422));
            uint _623 = asuint(_622);
            float _624 = mad(_377, _610, asfloat(_424));
            uint _625 = asuint(_624);
            float _627 = mad(_380, _610, asfloat(_432));
            uint _628 = asuint(_627);
            float _630 = ((-0.0f) - _616) + T2.Load(int3(uint2(uint(_582), uint(_583)), _436)).x;
            if (0.0f < _630)
            {
                bool _647 = _630 < _410;
                bool _652 = _326 < _627;
                float _691 = max((-0.0f) - _610, _630 / _389);
                bool _700 = _436 != 0u;
                bool _707 = _436 != 0u;
                bool _714 = _436 != 0u;
                _431 = asfloat(_714 ? asuint(mad(_389, _691, _616)) : (_647 ? asuint(mad(_386, _368, _616)) : (_652 ? asuint(mad(_389, _407, _616)) : asuint(_616))));
                _437 = (_714 ? _436 : (_647 ? 0u : uint(_652))) + 4294967295u;
                _439 = _714 ? _438 : (_647 ? 4294967295u : 0u);
                _421 = _700 ? asuint(mad(_375, _691, _620)) : (_647 ? _621 : (_652 ? asuint(mad(_375, _407, _620)) : _621));
                _423 = _700 ? asuint(mad(_376, _691, _622)) : (_647 ? _623 : (_652 ? asuint(mad(_376, _407, _622)) : _623));
                _425 = _700 ? asuint(mad(_377, _691, _624)) : (_647 ? _625 : (_652 ? asuint(mad(_377, _407, _624)) : _625));
                _739 = asfloat(_707 ? asuint(mad(_387, _691, _614)) : (_647 ? asuint(mad(_384, _368, _614)) : (_652 ? asuint(mad(_387, _407, _614)) : asuint(_614))));
                _740 = asfloat(_707 ? asuint(mad(_388, _691, _615)) : (_647 ? asuint(mad(_385, _368, _615)) : (_652 ? asuint(mad(_388, _407, _615)) : asuint(_615))));
                _433 = _714 ? asuint(mad(_380, _691, _627)) : (_647 ? _628 : (_652 ? asuint(mad(_380, _407, _627)) : _628));
            }
            else
            {
                _431 = _616;
                _437 = _436 + 1u;
                _439 = _438;
                _421 = _621;
                _423 = _623;
                _425 = _625;
                _739 = _614;
                _740 = _615;
                _433 = _628;
            }
            _419 = ((_740 >= _343) ? 4294967295u : 0u) | (((_740 < 0.0f) ? 4294967295u : 0u) | (((_739 < 0.0f) ? 4294967295u : 0u) | ((_739 >= _342) ? 4294967295u : 0u)));
            if (_419 != 0u)
            {
                _446 = 4294967295u;
                _447 = _421;
                _448 = _423;
                _449 = _425;
                _450 = asuint(_739);
                _453 = asuint(_740);
                _456 = _433;
                _457 = _439;
                break;
            }
            else
            {
                _435 = _434 + 1u;
                if (!(int(48u) < int(_434)))
                {
                    _418 = _419;
                    _420 = _421;
                    _422 = _423;
                    _424 = _425;
                    _426 = asuint(_739);
                    _428 = asuint(_740);
                    _430 = _431;
                    _432 = _433;
                    _434 = _435;
                    _436 = _437;
                    _438 = _439;
                    continue;
                }
                _446 = _419;
                _447 = _421;
                _448 = _423;
                _449 = _425;
                _450 = asuint(_739);
                _453 = asuint(_740);
                _456 = _433;
                _457 = _439;
                break;
            }
        }
    }
    float _461 = asfloat(_456);
    float _462 = asfloat(_447) / _461;
    float _463 = asfloat(_448) / _461;
    float _464 = asfloat(_449) / _461;
    float _467 = asfloat(_450) / _342;
    float _468 = asfloat(_453) / _343;
    float _475 = min(min(_468, ((-0.0f) - _468) + 1.0f), min(_467, ((-0.0f) - _467) + 1.0f));
    float _484 = asfloat((0.1500000059604644775390625f < _475) ? 1065353216u : asuint(clamp(_475 * 6.666666507720947265625f, 0.0f, 1.0f)));
    uint _486 = (_446 | _457) ^ 4294967295u;
    float4 _490 = T4.Sample(S1, float2(_61, _62));
    float _492 = _490.x;
    uint _527 = (clamp((mad(CB0_m0[11u].z, TEXCOORD.z, mad(CB0_m0[9u].z, TEXCOORD.x, TEXCOORD.y * CB0_m0[10u].z)) + CB0_m0[12u].z) / (mad(CB0_m0[11u].w, TEXCOORD.z, mad(CB0_m0[9u].w, TEXCOORD.x, TEXCOORD.y * CB0_m0[10u].w)) + CB0_m0[12u].w), 0.0f, 1.0f) < _492) ? 4294967295u : 0u;
    bool _532 = 0.0f != CB0_m0[13u].x;
    uint _566 = (_532 ? (_527 ^ 4294967295u) : _527) ^ 4294967295u;
    uint _569 = (_457 ^ 4294967295u) | (_566 & ((clamp((mad(CB0_m0[11u].z, _464, mad(CB0_m0[9u].z, _462, _463 * CB0_m0[10u].z)) + CB0_m0[12u].z) / (mad(CB0_m0[11u].w, _464, mad(CB0_m0[9u].w, _462, _463 * CB0_m0[10u].w)) + CB0_m0[12u].w), 0.0f, 1.0f) < (_492 + (-0.004999999888241291046142578125f))) ? 4294967295u : 0u));
    float _723;
    float _724;
    float _725;
    float _726;
    float _727;
    if (((((_484 < 1.0f) ? 4294967295u : 0u) | _569) & (_566 & (_532 ? 4294967295u : 0u))) != 0u)
    {
        float4 _633 = T3.Sample(S1, float2(_61, _62));
        float _638 = _633.w;
        _723 = _638;
        _724 = _633.z;
        _725 = _633.y;
        _726 = _633.x;
        _727 = asfloat(((_638 < 0.5f) ? 4294967295u : 0u) & _486);
    }
    else
    {
        _723 = asfloat(0u);
        _724 = asfloat(0u);
        _725 = asfloat(0u);
        _726 = asfloat(0u);
        _727 = asfloat(_486);
    }
    float _736 = asfloat((asuint(_727) != 0u) ? 0u : ((_569 != 0u) ? asuint(((-0.0f) - _723) + 1.0f) : 1065353216u));
    float _737 = _736 * _484;
    float _776;
    float _777;
    float _778;
    if (0.0f < _737)
    {
        float4 _753 = T0.Sample(S0, float2(_467, _468));
        float4 _759 = T1.Sample(S0, float2(_467, _468));
        float _764 = _759.w;
        _776 = _737 * mad(_753.z, _764, _759.z);
        _777 = _737 * mad(_753.y, _764, _759.y);
        _778 = _737 * mad(_753.x, _764, _759.x);
    }
    else
    {
        _776 = asfloat(0u);
        _777 = asfloat(0u);
        _778 = asfloat(0u);
    }
    bool _779 = _737 < 1.0f;
    float _781 = mad((-0.0f) - _484, _736, 1.0f);
    float _801 = asfloat(_779 ? asuint(mad(_723, _781, _737)) : asuint(_737));
    uint _803 = (0.0f < _801) ? 4294967295u : 0u;
    SV_Target.x = asfloat(_803 & asuint(asfloat(_779 ? asuint(mad(_726, _781, _778)) : asuint(_778)) / _801));
    SV_Target.y = asfloat(_803 & asuint(asfloat(_779 ? asuint(mad(_725, _781, _777)) : asuint(_777)) / _801));
    SV_Target.z = asfloat(_803 & asuint(asfloat(_779 ? asuint(mad(_724, _781, _776)) : asuint(_776)) / _801));
    float4 _820 = T0.Sample(S0, float2(_61, _62));
    float4 _826 = T1.Sample(S0, float2(_61, _62));
    float _831 = _826.w;
    SV_Target_1.x = mad(_820.x, _831, _826.x);
    SV_Target_1.y = mad(_820.y, _831, _826.y);
    SV_Target_1.z = mad(_820.z, _831, _826.z);
    SV_Target.w = _801;
    SV_Target_1.w = 1.0f;
    SV_Target_2.y = 0.0f;
    SV_Target_2.z = 0.0f;
    SV_Target_2.w = 0.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    TEXCOORD = stage_input.TEXCOORD;
    TEXCOORD_1 = stage_input.TEXCOORD_1;
    TEXCOORD_2 = stage_input.TEXCOORD_2;
    TEXCOORD_3 = stage_input.TEXCOORD_3;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.SV_Target = SV_Target;
    stage_output.SV_Target_1 = SV_Target_1;
    stage_output.SV_Target_2 = SV_Target_2;
    return stage_output;
}
