// Compile each entry separately with dxc -T ps_6_6 (or cs_6_6).

float4 ps_float4(float2 uv : TEXCOORD) : SV_Target {
  Texture2D<float4> texture = ResourceDescriptorHeap[1];
  SamplerState sampler = SamplerDescriptorHeap[2];
  return texture.Sample(sampler, uv);
}

float4 ps_float2_3d(float3 uv : TEXCOORD) : SV_Target {
  Texture3D<float2> texture = ResourceDescriptorHeap[3];
  SamplerState sampler = SamplerDescriptorHeap[4];
  return float4(texture.SampleLevel(sampler, uv, 0), 0, 1);
}

uint4 ps_uint4_load(uint2 xy : TEXCOORD) : SV_Target {
  Texture2D<uint4> texture = ResourceDescriptorHeap[5];
  return texture.Load(int3(xy, 0));
}

int4 ps_int4_buffer(uint index : TEXCOORD) : SV_Target {
  Buffer<int4> buffer = ResourceDescriptorHeap[6];
  return buffer.Load(index);
}

float4 ps_rw_texture(uint2 xy : TEXCOORD) : SV_Target {
  RWTexture2D<uint2> target = ResourceDescriptorHeap[7];
  target[xy] = xy;
  return float4(xy, 0, 1);
}

float4 ps_comparison(float2 uv : TEXCOORD) : SV_Target {
  Texture2D<float> texture = ResourceDescriptorHeap[8];
  SamplerComparisonState sampler = SamplerDescriptorHeap[9];
  return texture.SampleCmpLevelZero(sampler, uv, 0.5f);
}

float4 ps_nonuniform(float2 uv : TEXCOORD, nointerpolation uint index : INDEX) : SV_Target {
  Texture2D<float4> texture = ResourceDescriptorHeap[NonUniformResourceIndex(index)];
  SamplerState sampler = SamplerDescriptorHeap[10];
  return texture.Sample(sampler, uv);
}

float4 ps_raw(uint index : TEXCOORD) : SV_Target {
  ByteAddressBuffer buffer = ResourceDescriptorHeap[11];
  return asfloat(buffer.Load4(index));
}

struct Record { uint4 value; };
float4 ps_structured(uint index : TEXCOORD) : SV_Target {
  StructuredBuffer<Record> buffer = ResourceDescriptorHeap[12];
  return buffer[index].value;
}

struct Constants { float4 value; };
float4 ps_constant_buffer() : SV_Target {
  ConstantBuffer<Constants> buffer = ResourceDescriptorHeap[13];
  return buffer.value;
}
