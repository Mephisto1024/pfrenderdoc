// EID 9236; PS ResourceId::63245; Hidden/Internal-SSR-Water
// Approximate HLSL recovered from DXBC. Corrected Texture2D mip-count output of GetDimensions.
// ---- Created with 3Dmigoto v1.2.45 on Mon Sep 28 17:36:44 2026
Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[21];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[7];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[14];
}




// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1,
  out float4 o2 : SV_Target2)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v3.xy / v3.ww;
  r0.z = cmp(0.5 < cb0[2].z);
  r0.w = -v3.w * cb1[6].w + 1;
  o2.x = r0.z ? r0.w : 0;
  r1.xyz = cb1[5].xyz + -v1.xyz;
  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = rsqrt(r0.z);
  r1.xyz = r1.xyz * r0.zzz;
  r0.z = dot(-r1.xyz, v2.xyz);
  r0.z = r0.z + r0.z;
  r1.xyz = v2.xyz * -r0.zzz + -r1.xyz;
  r0.z = dot(r1.xyz, r1.xyz);
  r0.z = rsqrt(r0.z);
  r1.xyz = r1.xyz * r0.zzz;
  t2.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
  r0.z = uiDest.z;
  r2.xy = (uint2)cb0[8].xy;
  r3.xyz = cb2[10].xyz * r1.yyy;
  r3.xyz = cb2[9].xyz * r1.xxx + r3.xyz;
  r3.xyz = cb2[11].xyz * r1.zzz + r3.xyz;
  r0.w = dot(r3.xyz, r3.xyz);
  r0.w = rsqrt(r0.w);
  r0.w = r3.z * r0.w;
  r1.w = cmp(r0.w == 0.000000);
  r0.w = v1.w / r0.w;
  r0.w = r1.w ? 32 : r0.w;
  r1.w = cmp(r0.w < 0);
  r0.w = min(32, -r0.w);
  r0.w = r1.w ? r0.w : 32;
  r1.xyz = r1.xyz * r0.www + v1.xyz;
  r3.xyzw = cb2[18].xyzw * v1.yyyy;
  r3.xyzw = cb2[17].xyzw * v1.xxxx + r3.xyzw;
  r3.xyzw = cb2[19].xyzw * v1.zzzz + r3.xyzw;
  r3.xyzw = cb2[20].xyzw + r3.xyzw;
  r4.xyzw = cb2[18].xyzw * r1.yyyy;
  r4.xyzw = cb2[17].xyzw * r1.xxxx + r4.xyzw;
  r4.xyzw = cb2[19].xyzw * r1.zzzz + r4.xyzw;
  r4.xyzw = cb2[20].xyzw + r4.xyzw;
  r5.xz = float2(0.5,0.5);
  r5.y = cb1[6].x;
  r6.xyz = r5.zyz * r3.xyw;
  r6.w = 0.5 * r6.y;
  r3.xy = r6.xw + r6.zz;
  r5.xyz = r5.xyz * r4.xyw;
  r5.w = 0.5 * r5.y;
  r4.xy = r5.xw + r5.zz;
  r0.w = 1 / r3.w;
  r1.w = 1 / r4.w;
  r5.xyz = v1.xyz * r0.www;
  r3.xyz = r3.xyz * r0.www;
  r4.xyz = r4.xyz * r1.www;
  r2.xy = (uint2)r2.xy;
  r6.xy = r3.xy * r2.xy;
  r2.zw = r4.xy * r2.xy;
  r2.zw = cmp(r2.zw == r6.xy);
  r2.zw = r2.zw ? float2(0.00100000005,0.00100000005) : 0;
  r4.xy = r4.xy * r2.xy + r2.zw;
  r2.zw = -r3.xy * r2.xy + r4.xy;
  r2.z = dot(r2.zw, r2.zw);
  r2.z = sqrt(r2.z);
  r2.z = 1 / r2.z;
  r1.xyz = r1.xyz * r1.www + -r5.xyz;
  r1.xyz = r1.xyz * r2.zzz;
  r2.w = r1.w + -r0.w;
  r3.x = r2.w * r2.z;
  r6.z = r3.z;
  r3.yzw = -r6.xyz + r4.xyz;
  r4.xyz = r3.yzw * r2.zzz;
  r5.xyz = r3.yzw * r2.zzz + r6.xyz;
  r6.xyz = v1.xyz * r0.www + r1.xyz;
  r0.w = r2.w * r2.z + r0.w;
  r2.w = (int)r0.z + -1;
  r2.w = min(6, (uint)r2.w);
  r4.w = 0.0625 * r2.y;
  r4.w = max(1, r4.w);
  r7.xy = cmp(float2(0,0) < r4.xy);
  r5.w = -2 * r4.z;
  r8.z = 1;
  r9.z = 0;
  r10.xyz = r6.xyz;
  r7.zw = r5.xy;
  r6.w = 0;
  r11.z = r5.z;
  r8.w = r0.w;
  r10.w = 0;
  r11.w = r2.w;
  r12.w = 0;
  while (true) {
    r13.x = cmp((int)r11.w >= 0);
    r13.y = cmp((int)r11.w < (int)r0.z);
    r13.x = r13.y ? r13.x : 0;
    if (r13.x == 0) break;
    r13.x = 1 << (int)r11.w;
    r13.x = (uint)r13.x;
    r13.yz = r7.zw / r13.xx;
    r14.xy = (uint2)r13.yz;
    r14.zw = r11.ww;
    r13.w = t2.Load(r14.xyz).x;
    r14.xy = ceil(r13.yz);
    r13.yz = floor(r13.yz);
    r13.yz = r7.xy ? r14.xy : r13.yz;
    r13.yz = r13.yz * r13.xx + -r7.zw;
    r13.yz = r13.yz / r4.xy;
    r13.y = min(r13.y, r13.z);
    r13.x = r13.x * 0.0500000007 + r13.y;
    r11.xy = r7.zw;
    r11.xyz = r4.xyz * r13.xxx + r11.xyz;
    r14.xyz = r1.xyz * r13.xxx + r10.xyz;
    r9.x = r3.x * r13.x + r8.w;
    r13.y = r13.w + -r11.z;
    r13.z = cmp(0 < r13.y);
    if (r13.z != 0) {
      r15.w = cmp(r13.y < r5.w);
      r16.xyz = r3.yzw * r2.zzz + r11.xyz;
      r13.z = cmp(r1.w < r9.x);
      r17.xyz = r4.xyz * r4.www + r11.xyz;
      r18.xyz = r1.xyz * r4.www + r14.xyz;
      r8.y = r3.x * r4.w + r9.x;
      r8.x = r17.z;
      r9.y = r11.z;
      r19.xyz = r13.zzz ? r8.xyz : r9.yxz;
      r18.xyz = r13.zzz ? r18.xyz : r14.xyz;
      r8.xy = r13.zz ? r17.xy : r11.xy;
      r9.w = r16.z;
      r15.xyz = r15.www ? r9.wxz : r19.xyz;
      r17.xyz = r15.www ? r14.xyz : r18.xyz;
      r8.xy = r15.ww ? r16.xy : r8.xy;
      r9.y = r13.y / r4.z;
      r9.y = max(r9.y, -r13.x);
      r13.xyz = r4.xyz * r9.yyy + r11.xyz;
      r16.xyz = r1.xyz * r9.yyy + r14.xyz;
      r12.y = r3.x * r9.y + r9.x;
      r14.xyz = r11.www ? r16.xyz : r17.xyz;
      r11.xy = r11.ww ? r13.xy : r8.xy;
      r12.x = r13.z;
      r12.z = r14.w;
      r13.xyzw = r11.wwww ? r12.wxyz : r15.wxyz;
      r11.w = (int)r13.w + -1;
      r11.z = r13.y;
      r9.x = r13.z;
    } else {
      r11.w = (int)r11.w + 1;
      r13.x = r12.w;
    }
    r8.xy = cmp(r11.xy < float2(0,0));
    r9.yw = cmp(r11.xy >= r2.xy);
    r8.x = (int)r8.x | (int)r9.y;
    r8.x = (int)r8.y | (int)r8.x;
    r8.x = (int)r9.w | (int)r8.x;
    if (r8.x != 0) {
      r10.xyz = r14.xyz;
      r7.zw = r11.xy;
      r6.w = -1;
      r8.w = r9.x;
      r12.w = r13.x;
      break;
    }
    r8.y = (int)r10.w + 1;
    r9.y = cmp(48 < (int)r10.w);
    if (r9.y != 0) {
      r10.xyz = r14.xyz;
      r7.zw = r11.xy;
      r6.w = r8.x;
      r8.w = r9.x;
      r12.w = r13.x;
      break;
    }
    r10.w = r8.y;
    r10.xyz = r14.xyz;
    r7.zw = r11.xy;
    r6.w = r8.x;
    r8.w = r9.x;
    r12.w = r13.x;
  }
  r1.xyz = r10.xyz / r8.www;
  r0.zw = r7.zw / r2.xy;
  r2.xy = float2(1,1) + -r0.zw;
  r2.xy = min(r2.xy, r0.zw);
  r1.w = min(r2.x, r2.y);
  r2.x = cmp(0.150000006 < r1.w);
  r1.w = saturate(6.66666651 * r1.w);
  r1.w = r2.x ? 1 : r1.w;
  r2.x = (int)r6.w | (int)r12.w;
  r2.x = ~(int)r2.x;
  r2.y = t4.Sample(s1_s, r0.xy).x;
  r2.zw = cb0[10].zw * v1.yy;
  r2.zw = cb0[9].zw * v1.xx + r2.zw;
  r2.zw = cb0[11].zw * v1.zz + r2.zw;
  r2.zw = cb0[12].zw + r2.zw;
  r2.z = saturate(r2.z / r2.w);
  r2.z = cmp(r2.z < r2.y);
  r2.w = cmp(0 != cb0[13].x);
  r3.x = ~(int)r2.z;
  r2.z = r2.w ? r3.x : r2.z;
  r3.xy = cb0[10].zw * r1.yy;
  r1.xy = cb0[9].zw * r1.xx + r3.xy;
  r1.xy = cb0[11].zw * r1.zz + r1.xy;
  r1.xy = cb0[12].zw + r1.xy;
  r1.x = saturate(r1.x / r1.y);
  r1.y = -0.00499999989 + r2.y;
  r1.x = cmp(r1.x < r1.y);
  r1.y = ~(int)r2.z;
  r1.x = r1.x ? r1.y : 0;
  r1.z = ~(int)r12.w;
  r1.x = (int)r1.z | (int)r1.x;
  r1.y = r2.w ? r1.y : 0;
  r1.z = cmp(r1.w < 1);
  r1.z = (int)r1.z | (int)r1.x;
  r1.y = r1.z ? r1.y : 0;
  if (r1.y != 0) {
    r3.xyzw = t3.Sample(s1_s, r0.xy).xyzw;
    r1.y = cmp(r3.w < 0.5);
    r2.x = r1.y ? r2.x : 0;
  } else {
    r3.xyzw = float4(0,0,0,0);
  }
  r1.y = 1 + -r3.w;
  r1.x = r1.x ? r1.y : 1;
  r1.x = r2.x ? 0 : r1.x;
  r2.w = r1.w * r1.x;
  r1.y = cmp(0 < r2.w);
  if (r1.y != 0) {
    r4.xyz = t0.Sample(s0_s, r0.zw).xyz;
    r5.xyzw = t1.Sample(s0_s, r0.zw).xyzw;
    r4.xyz = r4.xyz * r5.www + r5.xyz;
    r2.xyz = r4.xyz * r2.www;
  } else {
    r2.xyz = float3(0,0,0);
  }
  r0.z = cmp(r2.w < 1);
  r0.w = -r1.w * r1.x + 1;
  r1.xyzw = r3.xyzw * r0.wwww + r2.xyzw;
  r1.xyzw = r0.zzzz ? r1.xyzw : r2.xyzw;
  r0.z = cmp(0 < r1.w);
  r1.xyz = r1.xyz / r1.www;
  o0.xyz = r0.zzz ? r1.xyz : 0;
  r1.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r0.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  o1.xyz = r1.xyz * r0.www + r0.xyz;
  o0.w = r1.w;
  o1.w = 1;
  o2.yzw = float3(0,0,0);
  return;
}