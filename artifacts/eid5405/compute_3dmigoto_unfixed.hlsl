// ---- Created with 3Dmigoto v1.2.45 on Tue Sep 29 17:49:16 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[1];
}




// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main()
{
// Needs manual fix for instruction: 
// unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u0
// Needs manual fix for instruction: 
// unknown dcl_: dcl_uav_structured u1, 4
// Needs manual fix for instruction: 
// unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u2
// Needs manual fix for instruction: 
// unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u3
// Needs manual fix for instruction: 
// unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u4
// Needs manual fix for instruction: 
// unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u5
// Needs manual fix for instruction: 
// unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u6
// Needs manual fix for instruction: 
// unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u7
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 x0[4];
// Needs manual fix for instruction: 
// unknown dcl_: dcl_tgsm_structured g0, 64, 16
// Needs manual fix for instruction: 
// unknown dcl_: dcl_tgsm_raw g1, 4
// Needs manual fix for instruction: 
// unknown dcl_: dcl_thread_group 256, 1, 1
  r0.x = (int)vThreadIDInGroupFlattened.x & 63;
  if (4 == 0) r0.y = 0; else if (4+2 < 32) {   r0.y = (uint)vThreadIDInGroupFlattened.x << (32-(4 + 2)); r0.y = (uint)r0.y >> (32-4);  } else r0.y = (uint)vThreadIDInGroupFlattened.x >> 2;
  if (3 == 0) r0.z = 0; else if (3+3 < 32) {   r0.z = (uint)vThreadIDInGroupFlattened.x << (32-(3 + 3)); r0.z = (uint)r0.z >> (32-3);  } else r0.z = (uint)vThreadIDInGroupFlattened.x >> 3;
  if (1 == 0) r0.w = 0; else if (1+6 < 32) {   r0.w = (uint)vThreadIDInGroupFlattened.x << (32-(1 + 6)); r0.w = (uint)r0.w >> (32-1);  } else r0.w = (uint)vThreadIDInGroupFlattened.x >> 6;
  r0.y = (int)r0.y & 6;
  bitmask.x = ((~(-1 << 1)) << 0) & 0xffffffff;  r1.x = (((uint)vThreadIDInGroupFlattened.x << 0) & bitmask.x) | ((uint)r0.y & ~bitmask.x);
  if (2 == 0) r0.x = 0; else if (2+1 < 32) {   r0.x = (uint)r0.x << (32-(2 + 1)); r0.x = (uint)r0.x >> (32-2);  } else r0.x = (uint)r0.x >> 1;
  bitmask.y = ((~(-1 << 2)) << 0) & 0xffffffff;  r1.y = (((uint)r0.x << 0) & bitmask.y) | ((uint)r0.z & ~bitmask.y);
  r2.y = mad((int)r0.w, 8, (int)r1.x);
  r1.x = (uint)vThreadIDInGroupFlattened.x >> 7;
  r2.z = mad((int)r1.x, 8, (int)r1.y);
  r1.y = (uint)r0.y << 1;
  bitmask.y = ((~(-1 << 1)) << 1) & 0xffffffff;  r1.y = (((uint)vThreadIDInGroupFlattened.x << 1) & bitmask.y) | ((uint)r1.y & ~bitmask.y);
  r3.w = mad((int)r0.w, 16, (int)r1.y);
  r1.y = (uint)r0.z << 1;
  bitmask.z = ((~(-1 << 2)) << 1) & 0xffffffff;  r1.z = (((uint)r0.x << 1) & bitmask.z) | ((uint)r1.y & ~bitmask.z);
  r3.y = mad((int)r1.x, 16, (int)r1.z);
  r1.zw = mad((int2)vThreadGroupID.xy, int2(64,64), (int2)r3.wy);
  r4.xyzw = mad((int4)vThreadGroupID.xyyy, int4(32,32,32,32), (int4)r2.yzzz);
  r1.zw = (int2)r1.zw + int2(1,1);
  r1.zw = (uint2)r1.zw;
  r5.xy = asuint(cb0[0].zw);
  r1.zw = r1.zw / r5.xy;
  r6.xyzw = t0.Gather(s0_s, r1.zw).xyzw;
  r1.zw = max(r6.xz, r6.yw);
  r1.z = max(r1.z, r1.w);
  x0[0].x = r1.z;
// No code for instruction (needs manual fix):
store_uav_typed u0.xyzw, r4.xyzw, r1.zzzz
  r3.xz = (int2)r3.wy + int2(32,32);
  r4.xyzw = mad((int4)vThreadGroupID.xyxy, int4(64,64,64,64), (int4)r3.xywz);
  r2.xw = (int2)r2.yz + int2(16,16);
  r6.xyzw = mad((int4)vThreadGroupID.xyyy, int4(32,32,32,32), (int4)r2.xzzz);
  r4.xyzw = (int4)r4.xyzw + int4(1,1,1,1);
  r4.xyzw = (uint4)r4.xyzw;
  r4.xyzw = r4.xyzw / r5.xyxy;
  r7.xyzw = t0.Gather(s0_s, r4.xy).xyzw;
  r1.zw = max(r7.xz, r7.yw);
  r1.z = max(r1.z, r1.w);
  x0[1].x = r1.z;
// No code for instruction (needs manual fix):
store_uav_typed u0.xyzw, r6.xyzw, r1.zzzz
  r6.xyzw = mad((int4)vThreadGroupID.xyyy, int4(32,32,32,32), (int4)r2.ywww);
  r4.xyzw = t0.Gather(s0_s, r4.zw).xyzw;
  r1.zw = max(r4.xz, r4.yw);
  r1.z = max(r1.z, r1.w);
  x0[2].x = r1.z;
// No code for instruction (needs manual fix):
store_uav_typed u0.xyzw, r6.xyzw, r1.zzzz
  r1.zw = mad((int2)vThreadGroupID.xy, int2(64,64), (int2)r3.xz);
  r4.xyzw = mad((int4)vThreadGroupID.xyyy, int4(32,32,32,32), (int4)r2.xwww);
  r1.zw = (int2)r1.zw | int2(33,33);
  r1.zw = (uint2)r1.zw;
  r1.zw = r1.zw / r5.xy;
  r5.xyzw = t0.Gather(s0_s, r1.zw).xyzw;
  r1.zw = max(r5.xz, r5.yw);
  r1.z = max(r1.z, r1.w);
  x0[3].x = r1.z;
// No code for instruction (needs manual fix):
store_uav_typed u0.xyzw, r4.xyzw, r1.zzzz
  r4.xyz = cmp(int3(1,2,6) < asuint(cb0[0].xxx));
  if (r4.x != 0) {
    r1.z = (uint)r0.z << 2;
    bitmask.z = ((~(-1 << 2)) << 2) & 0xffffffff;  r1.z = (((uint)r0.x << 2) & bitmask.z) | ((uint)r1.z & ~bitmask.z);
    r1.z = mad((int)r1.x, 32, (int)r1.z);
    r1.w = cmp((uint)vThreadIDInGroupFlattened.x < 64);
    r2.x = (int)r3.w + 1;
    r2.w = (uint)r1.y << 2;
    bitmask.w = ((~(-1 << 2)) << 3) & 0xffffffff;  r2.w = (((uint)r0.x << 3) & bitmask.w) | ((uint)r2.w & ~bitmask.w);
    r2.w = mad((int)r1.x, 64, (int)r2.w);
    r5.xyzw = (uint4)vThreadGroupID.xyyy << int4(4,4,4,4);
    r4.x = 0;
    while (true) {
      r4.w = cmp((uint)r4.x >= 4);
      if (r4.w != 0) break;
      r4.w = x0[r4.x+0].x;
      t0[r2.y].r1.z = g0.x;
      GroupMemoryBarrierWithGroupSync();
      if (r1.w != 0) {
      // Missing reflection info for shader. No names possible.
      // Known bad code for instruction (needs manual fix):
            ld_structured r6.xy, r3.w, r2.w, g0.xyxx
      r6.x = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
      r6.y = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
      // Missing reflection info for shader. No names possible.
      // Known bad code for instruction (needs manual fix):
            ld_structured r6.zw, r2.x, r2.w, g0.xxxy
      r6.z = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
      r6.w = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
        r6.xy = max(r6.xy, r6.zw);
        r4.w = max(r6.x, r6.y);
        x0[r4.x+0].x = r4.w;
        bitmask.x = ((~(-1 << 1)) << 3) & 0xffffffff;  r6.x = (((uint)r4.x << 3) & bitmask.x) | ((uint)0 & ~bitmask.x);
        r6.x = (int)r2.y + (int)r6.x;
        r7.x = (uint)r4.x >> 1;
        r7.x = (uint)r7.x << 3;
        r6.yzw = (int3)r2.zzz + (int3)r7.xxx;
        r6.xyzw = (int4)r5.xyzw + (int4)r6.xyzw;
      // No code for instruction (needs manual fix):
            store_uav_typed u2.xyzw, r6.xyzw, r4.wwww
      }
      GroupMemoryBarrierWithGroupSync();
      r4.x = (int)r4.x + 1;
    }
    if (r1.w != 0) {
      r1.w = x0[0].x;
      t0[r2.y].r1.z = g0.x;
      r1.w = (int)r2.y + 8;
      r2.x = x0[1].x;
      t0[r1.w].r1.z = g0.x;
      r2.x = x0[2].x;
      r1.z = (int)r1.z + 32;
      t0[r2.y].r1.z = g0.x;
      r2.x = x0[3].x;
      t0[r1.w].r1.z = g0.x;
    }
  }
  if (r4.y != 0) {
    GroupMemoryBarrierWithGroupSync();
    r1.z = cmp((uint)vThreadIDInGroupFlattened.x < 64);
    if (r1.z != 0) {
      r1.z = (int)r3.w + 1;
      r1.y = (uint)r1.y << 2;
      bitmask.y = ((~(-1 << 2)) << 3) & 0xffffffff;  r1.y = (((uint)r0.x << 3) & bitmask.y) | ((uint)r1.y & ~bitmask.y);
      r1.y = mad((int)r1.x, 64, (int)r1.y);
    // Missing reflection info for shader. No names possible.
    // Known bad code for instruction (needs manual fix):
        ld_structured r1.w, r3.w, r1.y, g0.xxxx
    r1.w = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
    // Missing reflection info for shader. No names possible.
    // Known bad code for instruction (needs manual fix):
        ld_structured r2.x, r1.z, r1.y, g0.xxxx
    r2.x = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
      r2.w = (int)r1.y + 4;
    // Missing reflection info for shader. No names possible.
    // Known bad code for instruction (needs manual fix):
        ld_structured r4.x, r3.w, r2.w, g0.xxxx
    r4.x = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
    // Missing reflection info for shader. No names possible.
    // Known bad code for instruction (needs manual fix):
        ld_structured r1.z, r1.z, r2.w, g0.xxxx
    r1.z = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
      r1.w = max(r2.x, r1.w);
      r1.z = max(r4.x, r1.z);
      r1.z = max(r1.w, r1.z);
      r5.xyzw = (uint4)vThreadGroupID.xyyy << int4(3,3,3,3);
      r5.xyzw = (int4)r2.yzzz + (int4)r5.xyzw;
    // No code for instruction (needs manual fix):
        store_uav_typed u3.xyzw, r5.xyzw, r1.zzzz
      bitmask.w = ((~(-1 << 1)) << 0) & 0xffffffff;  r1.w = (((uint)r2.z << 0) & bitmask.w) | ((uint)r3.w & ~bitmask.w);
      t0[r1.w].r1.y = g0.x;
    }
    r1.y = cmp(3 < asuint(cb0[0].x));
    if (r1.y != 0) {
      GroupMemoryBarrierWithGroupSync();
      r1.y = cmp((uint)vThreadIDInGroupFlattened.x < 16);
      if (r1.y != 0) {
        r1.yw = (uint2)r0.yz << int2(2,4);
        bitmask.y = ((~(-1 << 1)) << 2) & 0xffffffff;  r1.y = (((uint)vThreadIDInGroupFlattened.x << 2) & bitmask.y) | ((uint)r1.y & ~bitmask.y);
        r1.y = mad((int)r0.w, 32, (int)r1.y);
        r1.z = mad((int)r2.y, 4, 2);
        r2.xw = (int2)r1.yy + int2(1,3);
        bitmask.w = ((~(-1 << 2)) << 4) & 0xffffffff;  r1.w = (((uint)r0.x << 4) & bitmask.w) | ((uint)r1.w & ~bitmask.w);
        r1.w = mad((int)r1.x, 128, (int)r1.w);
      // Missing reflection info for shader. No names possible.
      // Known bad code for instruction (needs manual fix):
            ld_structured r4.x, r1.y, r1.w, g0.xxxx
      r4.x = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
      // Missing reflection info for shader. No names possible.
      // Known bad code for instruction (needs manual fix):
            ld_structured r1.z, r1.z, r1.w, g0.xxxx
      r1.z = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
        r4.y = (int)r1.w + 8;
      // Missing reflection info for shader. No names possible.
      // Known bad code for instruction (needs manual fix):
            ld_structured r2.x, r2.x, r4.y, g0.xxxx
      r2.x = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
      // Missing reflection info for shader. No names possible.
      // Known bad code for instruction (needs manual fix):
            ld_structured r2.w, r2.w, r4.y, g0.xxxx
      r2.w = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
        r1.z = max(r4.x, r1.z);
        r2.x = max(r2.x, r2.w);
        r1.z = max(r2.x, r1.z);
        r5.xyzw = (uint4)vThreadGroupID.xyyy << int4(2,2,2,2);
        r5.xyzw = (int4)r2.yzzz + (int4)r5.xyzw;
      // No code for instruction (needs manual fix):
            store_uav_typed u4.xyzw, r5.xyzw, r1.zzzz
        r1.y = (int)r2.z + (int)r1.y;
        t0[r1.y].r1.w = g0.x;
      }
      r1.y = cmp(4 < asuint(cb0[0].x));
      if (r1.y != 0) {
        GroupMemoryBarrierWithGroupSync();
        r1.y = cmp((uint)vThreadIDInGroupFlattened.x < 4);
        if (r1.y != 0) {
          r0.yz = (uint2)r0.yz << int2(3,5);
          bitmask.y = ((~(-1 << 1)) << 3) & 0xffffffff;  r0.y = (((uint)vThreadIDInGroupFlattened.x << 3) & bitmask.y) | ((uint)r0.y & ~bitmask.y);
          r0.y = mad((int)r0.w, 64, (int)r0.y);
          r0.w = (int)r3.y + (int)r0.y;
          r1.yz = mad((int2)r2.yy, int2(8,8), int2(4,5));
          r0.y = (int)r0.y + 1;
          r0.y = (int)r3.y + (int)r0.y;
          r1.yz = (int2)r3.yy + (int2)r1.yz;
          bitmask.x = ((~(-1 << 2)) << 5) & 0xffffffff;  r0.x = (((uint)r0.x << 5) & bitmask.x) | ((uint)r0.z & ~bitmask.x);
          r0.x = mad((int)r1.x, 256, (int)r0.x);
        // Missing reflection info for shader. No names possible.
        // Known bad code for instruction (needs manual fix):
                ld_structured r0.z, r0.w, r0.x, g0.xxxx
        r0.z = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
        // Missing reflection info for shader. No names possible.
        // Known bad code for instruction (needs manual fix):
                ld_structured r0.w, r1.y, r0.x, g0.xxxx
        r0.w = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
          r0.x = (int)r0.x + 16;
        // Missing reflection info for shader. No names possible.
        // Known bad code for instruction (needs manual fix):
                ld_structured r0.y, r0.y, r0.x, g0.xxxx
        r0.y = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
        // Missing reflection info for shader. No names possible.
        // Known bad code for instruction (needs manual fix):
                ld_structured r0.x, r1.z, r0.x, g0.xxxx
        r0.x = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
          r0.xz = max(r0.yz, r0.xw);
          r0.x = max(r0.z, r0.x);
          r1.xyzw = (uint4)vThreadGroupID.xyyy << int4(1,1,1,1);
          r1.xyzw = (int4)r2.yzzz + (int4)r1.xyzw;
        // No code for instruction (needs manual fix):
                store_uav_typed u5.xyzw, r1.xyzw, r0.xxxx
          r0.y = (int)r2.y + (int)r3.y;
          t0[r0.y].0 = g0.x;
        }
        r0.x = cmp(5 < asuint(cb0[0].x));
        if (r0.x != 0) {
          GroupMemoryBarrierWithGroupSync();
          r0.x = cmp((uint)vThreadIDInGroupFlattened.x < 1);
          if (r0.x != 0) {
          // Missing reflection info for shader. No names possible.
          // Known bad code for instruction (needs manual fix):
                    ld_structured r0.x, l(0), l(0), g0.xxxx
          r0.x = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
          // Missing reflection info for shader. No names possible.
          // Known bad code for instruction (needs manual fix):
                    ld_structured r0.y, l(1), l(0), g0.xxxx
          r0.y = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
          // Missing reflection info for shader. No names possible.
          // Known bad code for instruction (needs manual fix):
                    ld_structured r0.z, l(2), l(0), g0.xxxx
          r0.z = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
          // Missing reflection info for shader. No names possible.
          // Known bad code for instruction (needs manual fix):
                    ld_structured r0.w, l(3), l(0), g0.xxxx
          r0.w = no_StructuredBufferName[no_srcAddressRegister].no_srcByteOffsetName.swiz;
            r0.x = max(r0.x, r0.y);
            r0.y = max(r0.z, r0.w);
            r0.x = max(r0.x, r0.y);
          // No code for instruction (needs manual fix):
                    store_uav_typed u6.xyzw, vThreadGroupID.xyyy, r0.xxxx
          }
        }
      }
    }
  }
  if (r4.z != 0) {
    if (vThreadIDInGroupFlattened.x == 0) {
      // Needs manual fix for instruction:
        imm_atomic_iadd r0.x, u1, l(0, 0, 0, 0), l(1)
      InterlockedAdd(dest, imm_value, orig_value);
    // No code for instruction (needs manual fix):
        store_raw g1.x, l(0), r0.x
    }
    GroupMemoryBarrierWithGroupSync();
  // No code for instruction (needs manual fix):
    ld_raw r0.x, l(0), g1.xxxx
    r0.y = asint(cb0[0].y) + -1;
    r0.x = cmp((int)r0.y == (int)r0.x);
    if (r0.x != 0) {
    // No code for instruction (needs manual fix):
        store_uav_typed u7.xyzw, r3.wyyy, l(0,0,0,0)
      r3.xz = (int2)r3.wy + int2(1,1);
    // No code for instruction (needs manual fix):
        store_uav_typed u7.xyzw, r3.xyyy, l(0,0,0,0)
    // No code for instruction (needs manual fix):
        store_uav_typed u7.xyzw, r3.wzzz, l(0,0,0,0)
    // No code for instruction (needs manual fix):
        store_uav_typed u7.xyzw, r3.xzzz, l(0,0,0,0)
    }
  }
  return;
}