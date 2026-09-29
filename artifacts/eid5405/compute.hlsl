cbuffer CB0UBO : register(b0)
{
    float4 CB0_m0[1] : packoffset(c0);
};

Texture2D<float4> T0 : register(t0);
RWTexture2D<float4> U0 : register(u0);
RWStructuredBuffer<uint> U1 : register(u1);
RWTexture2D<float4> U2 : register(u2);
RWTexture2D<float4> U3 : register(u3);
RWTexture2D<float4> U4 : register(u4);
RWTexture2D<float4> U5 : register(u5);
RWTexture2D<float4> U6 : register(u6);
RWTexture2D<float4> U7 : register(u7);
SamplerState S0 : register(s0);

static uint3 gl_WorkGroupID;
static uint gl_LocalInvocationIndex;
struct SPIRV_Cross_Input
{
    uint3 gl_WorkGroupID : SV_GroupID;
    uint gl_LocalInvocationIndex : SV_GroupIndex;
};

groupshared uint _34[256];
groupshared uint _37[1];

uint spvBitfieldInsert(uint Base, uint Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint2 spvBitfieldInsert(uint2 Base, uint2 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint3 spvBitfieldInsert(uint3 Base, uint3 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint4 spvBitfieldInsert(uint4 Base, uint4 Insert, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : (((1u << Count) - 1) << (Offset & 31));
    return (Base & ~Mask) | ((Insert << Offset) & Mask);
}

uint spvBitfieldUExtract(uint Base, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
    return (Base >> Offset) & Mask;
}

uint2 spvBitfieldUExtract(uint2 Base, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
    return (Base >> Offset) & Mask;
}

uint3 spvBitfieldUExtract(uint3 Base, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
    return (Base >> Offset) & Mask;
}

uint4 spvBitfieldUExtract(uint4 Base, uint Offset, uint Count)
{
    uint Mask = Count == 32 ? 0xffffffff : ((1 << Count) - 1);
    return (Base >> Offset) & Mask;
}

int spvBitfieldSExtract(int Base, int Offset, int Count)
{
    int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
    int Masked = (Base >> Offset) & Mask;
    int ExtendShift = (32 - Count) & 31;
    return (Masked << ExtendShift) >> ExtendShift;
}

int2 spvBitfieldSExtract(int2 Base, int Offset, int Count)
{
    int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
    int2 Masked = (Base >> Offset) & Mask;
    int ExtendShift = (32 - Count) & 31;
    return (Masked << ExtendShift) >> ExtendShift;
}

int3 spvBitfieldSExtract(int3 Base, int Offset, int Count)
{
    int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
    int3 Masked = (Base >> Offset) & Mask;
    int ExtendShift = (32 - Count) & 31;
    return (Masked << ExtendShift) >> ExtendShift;
}

int4 spvBitfieldSExtract(int4 Base, int Offset, int Count)
{
    int Mask = Count == 32 ? -1 : ((1 << Count) - 1);
    int4 Masked = (Base >> Offset) & Mask;
    int ExtendShift = (32 - Count) & 31;
    return (Masked << ExtendShift) >> ExtendShift;
}

void comp_main()
{
    uint _61 = 2u & 31u;
    uint _70 = 3u & 31u;
    uint _73 = spvBitfieldUExtract(gl_LocalInvocationIndex, _70, min((3u & 31u), (32u - _70)));
    uint _75 = 6u & 31u;
    uint _79 = spvBitfieldUExtract(gl_LocalInvocationIndex, _75, min((1u & 31u), (32u - _75)));
    uint _80 = spvBitfieldUExtract(gl_LocalInvocationIndex, _61, min((4u & 31u), (32u - _61))) & 6u;
    uint _83 = 0u & 31u;
    uint _89 = 1u & 31u;
    uint _92 = spvBitfieldUExtract(gl_LocalInvocationIndex & 63u, _89, min((2u & 31u), (32u - _89)));
    uint _94 = 0u & 31u;
    uint _100 = (_79 * 8u) + spvBitfieldInsert(_80, gl_LocalInvocationIndex, _83, min((1u & 31u), (32u - _83)));
    uint _102 = gl_LocalInvocationIndex >> 7u;
    uint _105 = (_102 * 8u) + spvBitfieldInsert(_73, _92, _94, min((2u & 31u), (32u - _94)));
    uint _109 = 1u & 31u;
    uint _114 = (_79 * 16u) + spvBitfieldInsert(_80 << 1u, gl_LocalInvocationIndex, _109, min((1u & 31u), (32u - _109)));
    uint _115 = _73 << 1u;
    uint _117 = 1u & 31u;
    uint _122 = (_102 * 16u) + spvBitfieldInsert(_115, _92, _117, min((2u & 31u), (32u - _117)));
    uint4 _151 = asuint(CB0_m0[0u]);
    float _154 = float(_151.z);
    float _155 = float(_151.w);
    float4 _162 = T0.GatherRed(S0, float2(float(((gl_WorkGroupID.x * 64u) + _114) + 1u) / _154, float(((gl_WorkGroupID.y * 64u) + _122) + 1u) / _155));
    float _169 = max(max(_162.w, _162.z), max(_162.y, _162.x));
    uint _41[16];
    _41[0u] = asuint(_169);
    U0[uint2((gl_WorkGroupID.x * 32u) + _100, (gl_WorkGroupID.y * 32u) + _105)] = _169.xxxx;
    uint _176 = _114 + 32u;
    uint _177 = _122 + 32u;
    uint _190 = _100 + 16u;
    uint _191 = _105 + 16u;
    float4 _213 = T0.GatherRed(S0, float2(float(((gl_WorkGroupID.x * 64u) + _176) + 1u) / _154, float(((gl_WorkGroupID.y * 64u) + _122) + 1u) / _155));
    float _220 = max(max(_213.w, _213.z), max(_213.y, _213.x));
    _41[4u] = asuint(_220);
    U0[uint2((gl_WorkGroupID.x * 32u) + _190, (gl_WorkGroupID.y * 32u) + _105)] = _220.xxxx;
    float4 _234 = T0.GatherRed(S0, float2(float(((gl_WorkGroupID.x * 64u) + _114) + 1u) / _154, float(((gl_WorkGroupID.y * 64u) + _177) + 1u) / _155));
    float _241 = max(max(_234.w, _234.z), max(_234.y, _234.x));
    _41[8u] = asuint(_241);
    U0[uint2((gl_WorkGroupID.x * 32u) + _100, (gl_WorkGroupID.y * 32u) + _191)] = _241.xxxx;
    float4 _270 = T0.GatherRed(S0, float2(float(((gl_WorkGroupID.x * 64u) + _176) | 33u) / _154, float(((gl_WorkGroupID.y * 64u) + _177) | 33u) / _155));
    float _277 = max(max(_270.w, _270.z), max(_270.y, _270.x));
    _41[12u] = asuint(_277);
    U0[uint2((gl_WorkGroupID.x * 32u) + _190, (gl_WorkGroupID.y * 32u) + _191)] = _277.xxxx;
    uint4 _285 = asuint(CB0_m0[0u]);
    uint _286 = _285.x;
    if (1u < _286)
    {
        uint _293 = 2u & 31u;
        uint _298 = (_102 * 32u) + spvBitfieldInsert(_73 << 2u, _92, _293, min((2u & 31u), (32u - _293)));
        bool _300 = gl_LocalInvocationIndex < 64u;
        uint _301 = _114 + 1u;
        uint _304 = 3u & 31u;
        uint _309 = (_102 * 64u) + spvBitfieldInsert(_115 << 2u, _92, _304, min((2u & 31u), (32u - _304)));
        uint _314 = gl_WorkGroupID.x << 4u;
        uint _315 = gl_WorkGroupID.y << 4u;
        for (uint _316 = 0u; !(_316 >= 4u); GroupMemoryBarrierWithGroupSync(), _316++)
        {
            _34[((_100 * 64u) + _298) >> 2u] = asuint(asfloat(_41[(_316 * 4u) + 0u]));
            GroupMemoryBarrierWithGroupSync();
            if (_300)
            {
                uint _432 = (_114 * 64u) + _309;
                uint _443 = (_301 * 64u) + _309;
                float _455 = max(max(asfloat(_34[(_443 + 4u) >> 2u]), asfloat(_34[(_432 + 4u) >> 2u])), max(asfloat(_34[_443 >> 2u]), asfloat(_34[_432 >> 2u])));
                _41[(_316 * 4u) + 0u] = asuint(_455);
                uint _461 = 3u & 31u;
                U2[uint2(_314 + (_100 + spvBitfieldInsert(0u, _316, _461, min((1u & 31u), (32u - _461)))), _315 + (_105 + ((_316 >> 1u) << 3u)))] = _455.xxxx;
            }
        }
        if (_300)
        {
            _34[((_100 * 64u) + _298) >> 2u] = asuint(asfloat(_41[0u]));
            uint _405 = _100 + 8u;
            _34[((_405 * 64u) + _298) >> 2u] = asuint(asfloat(_41[4u]));
            uint _416 = _298 + 32u;
            _34[((_100 * 64u) + _416) >> 2u] = asuint(asfloat(_41[8u]));
            _34[((_405 * 64u) + _416) >> 2u] = asuint(asfloat(_41[12u]));
        }
    }
    if (2u < _286)
    {
        GroupMemoryBarrierWithGroupSync();
        if (gl_LocalInvocationIndex < 64u)
        {
            uint _333 = _114 + 1u;
            uint _336 = 3u & 31u;
            uint _341 = (_102 * 64u) + spvBitfieldInsert(_115 << 2u, _92, _336, min((2u & 31u), (32u - _336)));
            uint _354 = _341 + 4u;
            float _369 = max(max(asfloat(_34[((_333 * 64u) + _354) >> 2u]), asfloat(_34[((_114 * 64u) + _354) >> 2u])), max(asfloat(_34[((_114 * 64u) + _341) >> 2u]), asfloat(_34[((_333 * 64u) + _341) >> 2u])));
            U3[uint2(_100 + (gl_WorkGroupID.x << 3u), _105 + (gl_WorkGroupID.y << 3u))] = _369.xxxx;
            uint _381 = 0u & 31u;
            _34[((spvBitfieldInsert(_114, _105, _381, min((1u & 31u), (32u - _381))) * 64u) + _341) >> 2u] = asuint(_369);
        }
        if (3u < asuint(CB0_m0[0u]).x)
        {
            GroupMemoryBarrierWithGroupSync();
            if (gl_LocalInvocationIndex < 16u)
            {
                uint _494 = 2u & 31u;
                uint _499 = (_79 * 32u) + spvBitfieldInsert(_80 << 2u, gl_LocalInvocationIndex, _494, min((1u & 31u), (32u - _494)));
                uint _505 = 4u & 31u;
                uint _511 = (_102 * 128u) + spvBitfieldInsert(_73 << 4u, _92, _505, min((2u & 31u), (32u - _505)));
                uint _524 = _511 + 8u;
                float _539 = max(max(asfloat(_34[((((_100 * 4u) + 2u) * 64u) + _511) >> 2u]), asfloat(_34[((_499 * 64u) + _511) >> 2u])), max(asfloat(_34[(((_499 + 3u) * 64u) + _524) >> 2u]), asfloat(_34[(((_499 + 1u) * 64u) + _524) >> 2u])));
                U4[uint2(_100 + (gl_WorkGroupID.x << 2u), _105 + (gl_WorkGroupID.y << 2u))] = _539.xxxx;
                _34[(((_105 + _499) * 64u) + _511) >> 2u] = asuint(_539);
            }
            if (4u < asuint(CB0_m0[0u]).x)
            {
                GroupMemoryBarrierWithGroupSync();
                if (gl_LocalInvocationIndex < 4u)
                {
                    uint _579 = 3u & 31u;
                    uint _584 = (_79 * 64u) + spvBitfieldInsert(_80 << 3u, gl_LocalInvocationIndex, _579, min((1u & 31u), (32u - _579)));
                    uint _595 = 5u & 31u;
                    uint _600 = (_102 * 256u) + spvBitfieldInsert(_73 << 5u, _92, _595, min((2u & 31u), (32u - _595)));
                    uint _613 = _600 + 16u;
                    float _628 = max(max(asfloat(_34[(((_122 + ((_100 * 8u) + 5u)) * 64u) + _613) >> 2u]), asfloat(_34[(((_122 + (_584 + 1u)) * 64u) + _613) >> 2u])), max(asfloat(_34[(((_122 + ((_100 * 8u) + 4u)) * 64u) + _600) >> 2u]), asfloat(_34[(((_122 + _584) * 64u) + _600) >> 2u])));
                    U5[uint2(_100 + (gl_WorkGroupID.x << 1u), _105 + (gl_WorkGroupID.y << 1u))] = _628.xxxx;
                    uint _639 = _100 + _122;
                    _34[_639 * 16u] = asuint(_628);
                }
                if (5u < asuint(CB0_m0[0u]).x)
                {
                    GroupMemoryBarrierWithGroupSync();
                    if (gl_LocalInvocationIndex < 1u)
                    {
                        U6[uint2(gl_WorkGroupID.x, gl_WorkGroupID.y)] = max(max(asfloat(_34[48u]), asfloat(_34[32u])), max(asfloat(_34[16u]), asfloat(_34[0u]))).xxxx;
                    }
                }
            }
        }
    }
    if (6u < _286)
    {
        if (gl_LocalInvocationIndex == 0u)
        {
            uint _477;
            InterlockedAdd(U1[0u], 1u, _477);
            _37[0u] = (_477);
        }
        GroupMemoryBarrierWithGroupSync();
        if ((asuint(CB0_m0[0u]).y + 4294967295u) == (_37[0u]))
        {
            U7[uint2(_114, _122)] = 0.0f.xxxx;
            uint _564 = _114 + 1u;
            uint _565 = _122 + 1u;
            U7[uint2(_564, _122)] = 0.0f.xxxx;
            U7[uint2(_114, _565)] = 0.0f.xxxx;
            U7[uint2(_564, _565)] = 0.0f.xxxx;
        }
    }
}

[numthreads(256, 1, 1)]
void main(SPIRV_Cross_Input stage_input)
{
    gl_WorkGroupID = stage_input.gl_WorkGroupID;
    gl_LocalInvocationIndex = stage_input.gl_LocalInvocationIndex;
    comp_main();
}
