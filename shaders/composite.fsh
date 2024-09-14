#version 330 compatibility

#include /lib/distort.glsl

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;


uniform vec3 shadowLightPosition;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

in vec2 texcoord;

vec3 projectAndDivide(mat4 projectionMatrix, vec3 position){
  vec4 homPos = projectionMatrix * vec4(position, 1.0);
  return homPos.xyz / homPos.w;
}

vec3 getShadow(vec3 shadowScreenPos){
  float transparentShadow = step(shadowScreenPos.z, texture(shadowtex0, shadowScreenPos.xy).r);

  // note that a value of 1.0 means 100% of sunlight is getting through, not that there is 100% shadowing

  if(transparentShadow == 1.0){ // no shadow at all
    return vec3(1.0);
  }

  float opaqueShadow = step(shadowScreenPos.z, texture(shadowtex1, shadowScreenPos.xy).r);

  if(opaqueShadow == 0.0){ // opaque shadow so don't sample transparent shadow color
    return vec3(0.0);
  }

  vec4 shadowColor = texture(shadowcolor0, shadowScreenPos.xy);

  return shadowColor.rgb * (1.0 - shadowColor.a); // the transparency of the caster is stored in shadowcolor0's alpha component
}

const vec3 torchColor = vec3(1.0, 0.5, 0.08);
const vec3 skyColor = vec3(0.05, 0.15, 0.3);
const vec3 sunlightColor = vec3(1.0);
const vec3 ambientColor = vec3(0.1);

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 color;

void main() {
	float depth = texture(depthtex0, texcoord).r;
	if(depth == 1.0){
	  return;
	}

	vec3 NDCPos = vec3(texcoord.xy, depth) * 2.0 - 1.0;
	vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);
	vec3 feetPlayerPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
	vec3 shadowViewPos = (shadowModelView * vec4(feetPlayerPos, 1.0)).xyz;
	vec4 shadowClipPos = shadowProjection * vec4(shadowViewPos, 1.0);
	shadowClipPos.z -= 0.001;
	shadowClipPos.xyz = distortShadowClipPos(shadowClipPos.xyz);
	vec3 shadowNDCPos = projectAndDivide(shadowProjection, shadowViewPos);
	vec3 shadowScreenPos = shadowNDCPos * 0.5 + 0.5;

	vec2 lightmap = texture(colortex1, texcoord).rg;
	vec3 encodedNormal = texture(colortex2, texcoord).rgb;
	vec3 normal = normalize((encodedNormal - 0.5) * 2.0);
	vec3 shadow = getShadow(shadowScreenPos);

	vec3 lightVector = normalize(shadowLightPosition);
	vec3 worldLightVector = mat3(gbufferModelViewInverse) * lightVector;

	vec3 blocklight = lightmap.r * torchColor;
	vec3 skylight = lightmap.g * skyColor;
	vec3 ambient = ambientColor;
	vec3 sunlight = sunlightColor * dot(normal, worldLightVector) * shadow;

	color = texture(colortex0, texcoord);
	color.rgb *= blocklight + skylight + ambient + sunlight;
}
