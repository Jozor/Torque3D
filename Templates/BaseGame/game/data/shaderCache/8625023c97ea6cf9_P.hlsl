//*****************************************************************************
// Torque -- HLSL procedural shader
//*****************************************************************************

// Dependencies:
#include "core/rendering/shaders/lighting.hlsl"
//------------------------------------------------------------------------------
// Autogenerated 'Light Buffer Conditioner [RGB]' Uncondition Method
//------------------------------------------------------------------------------
inline void autogenUncondition_bde4cbab(in float4 bufferSample, out float3 lightColor, out float NL_att, out float specular)
{
   lightColor = bufferSample.rgb;
   NL_att = dot(bufferSample.rgb, float3(0.3576, 0.7152, 0.1192));
   specular = bufferSample.a;
}


#include "core/rendering/shaders/torque.hlsl"

// Features:
// Vert Position
// Diffuse Color
// Deferred RT Lighting
// Visibility
// HDR Output

struct ConnectData
{
   float4 vpos            : SV_Position;
   float4 screenspacePos  : TEXCOORD0;
};


struct Fragout
{
   float4 col : SV_Target0;
};


//-----------------------------------------------------------------------------
// Main
//-----------------------------------------------------------------------------
Fragout main( ConnectData IN,
              uniform float4    diffuseMaterialColor : register(C0),
              uniform float4    rtParamslightInfoBuffer : register(C2),
              uniform SamplerState lightInfoBuffer : register(S0),
              uniform Texture2D lightInfoBufferTex : register(T0),
              uniform float     visibility      : register(C1)
)
{
   Fragout OUT;

   // Vert Position
   
   // Diffuse Color
   OUT.col = diffuseMaterialColor;
   
   // Deferred RT Lighting
   float2 uvScene = IN.screenspacePos.xy / IN.screenspacePos.w;
   uvScene = ( uvScene + 1.0 ) / 2.0;
   uvScene.y = 1.0 - uvScene.y;
   uvScene = ( uvScene * rtParamslightInfoBuffer.zw ) + rtParamslightInfoBuffer.xy;
   float3 d_lightcolor;
   float d_NL_Att;
   float d_specular;
   lightinfoUncondition(lightInfoBufferTex.Sample(lightInfoBuffer, uvScene), d_lightcolor, d_NL_Att, d_specular);
   OUT.col *= float4(d_lightcolor, 1.0);
   
   // Visibility
   fizzle( IN.vpos.xy, visibility );
   
   // HDR Output
   OUT.col = hdrEncode( OUT.col );
   

   return OUT;
}
