//------------------------------------------------------------------------------
// Autogenerated 'Light Buffer Conditioner [RGB]' Condition Method
//------------------------------------------------------------------------------
inline float4 autogenCondition_bde4cbab(in float3 lightColor, in float NL_att, in float specular, in float4 bufferSample)
{
   float4 rgbLightInfoOut = float4(lightColor, 0) * NL_att + float4(bufferSample.rgb, specular);

   return rgbLightInfoOut;
}


//------------------------------------------------------------------------------
// Autogenerated 'Light Buffer Conditioner [RGB]' Uncondition Method
//------------------------------------------------------------------------------
inline void autogenUncondition_bde4cbab(in float4 bufferSample, out float3 lightColor, out float NL_att, out float specular)
{
   lightColor = bufferSample.rgb;
   NL_att = dot(bufferSample.rgb, float3(0.3576, 0.7152, 0.1192));
   specular = bufferSample.a;
}


//------------------------------------------------------------------------------
// Autogenerated 'GBuffer Conditioner' Condition Method
//------------------------------------------------------------------------------
inline float4 autogenCondition_55070f7a(in float4 unconditionedOutput)
{
   // g-buffer conditioner: float4(normal.X, normal.Y, depth Hi, depth Lo)
   float4 _gbConditionedOutput = float4(sqrt(half(2.0/(1.0 - unconditionedOutput.y))) * half2(unconditionedOutput.xz), 0.0, unconditionedOutput.a);
   
   // Encode depth into hi/lo
   float2 _tempDepth = frac(unconditionedOutput.a * float2(1.0, 65535.0));
   _gbConditionedOutput.zw = _tempDepth.xy - _tempDepth.yy * float2(1.0/65535.0, 0.0);


   return _gbConditionedOutput;
}


//------------------------------------------------------------------------------
// Autogenerated 'GBuffer Conditioner' Uncondition Method
//------------------------------------------------------------------------------
inline float4 autogenUncondition_55070f7a(SamplerState deferredSamplerVar, Texture2D deferredTexVar, float2 screenUVVar)
{
   // Sampler g-buffer
      float4 bufferSample = deferredTexVar.SampleLevel(deferredSamplerVar, screenUVVar,0);
   // g-buffer unconditioner: float4(normal.X, normal.Y, depth Hi, depth Lo)
   float2 _inpXY = bufferSample.xy;
   float _xySQ = dot(_inpXY, _inpXY);
   float4 _gbUnconditionedInput = float4( sqrt(half(1.0 - (_xySQ / 4.0))) * _inpXY, -1.0 + (_xySQ / 2.0), bufferSample.a).xzyw;
   
   // Decode depth
   _gbUnconditionedInput.w = dot( bufferSample.zw, float2(1.0, 1.0/65535.0));

   return _gbUnconditionedInput;
}


