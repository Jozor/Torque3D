//-----------------------------------------------------------------------------
// Copyright (c) 2012 GarageGames, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//-----------------------------------------------------------------------------

// An implementation of "Practical Morphological Anti-Aliasing" from 
// GPU Pro 2 by Jorge Jimenez, Belen Masia, Jose I. Echevarria, 
// Fernando Navarro, and Diego Gutierrez.
//
// http://www.iryoku.com/mlaa/

#include "core/rendering/shaders/gl/hlslCompat.glsl"

in vec4 vPosition;
in vec2 vTexCoord0;

#define IN_position  vPosition
#define IN_texcoord  vTexCoord0

#define OUT_position gl_Position
out vec2 texcoord;
#define OUT_texcoord texcoord
out vec4 offset[2];
#define OUT_offset offset

uniform vec2 texSize0;

void main()
{
   OUT_position = IN_position;
   vec2 PIXEL_SIZE = 1.0 / texSize0;

   OUT_texcoord = IN_texcoord;
   OUT_texcoord.xy += PIXEL_SIZE * 0.5;

   OUT_offset[0] = OUT_texcoord.xyxy + PIXEL_SIZE.xyxy * vec4(-1.0, 0.0, 0.0, -1.0);
   OUT_offset[1] = OUT_texcoord.xyxy + PIXEL_SIZE.xyxy * vec4( 1.0, 0.0, 0.0,  1.0);
   
   correctSSP(gl_Position);
}
