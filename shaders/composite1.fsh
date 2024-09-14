#version 330 compatibility

#include "/lib/distort.glsl"

#define FOG_DENSITY 5.0

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

vec3 fogColor;

uniform mat4 gbufferProjectionInverse;

in vec2 texcoord;

vec3 projectAndDivide(mat4 projectionMatrix, vec3 position){
  vec4 homPos = projectionMatrix * vec4(position, 1.0);
  return homPos.xyz / homPos.w;
}

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 color;

void main() {
  color = texture(colortex0, texcoord);

  float depth = texture(depthtex0, texcoord).r;
  if(depth == 1.0){
    return;
  }

  vec3 NDCPos = vec3(texcoord.xy, depth) * 2.0 - 1.0;
  vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);

  float distance = length(viewPos) / far;
  float fogFactor = exp(-FOG_DENSITY * (1.0 - distance));
  
  color.rgb = mix(color.rgb, fogColor, clamp(fogFactor, 0.0, 1.0));

}
