#include "/libs/settings.glsl"

#ifdef FRAGMENT_SHADER

#include "/libs/project_divide.glsl"
#include "/libs/distort.glsl"

uniform sampler2D shadowtex0;
uniform sampler2D depthtex0;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowProjectionInverse;

varying vec2 tex_coords;

void main() {
    float depth = texture(depthtex0, tex_coords).r;
    vec3 screenPos = vec3(tex_coords, depth);
    vec3 ndcPos = screenPos * 2 - 1;
    vec3 veiwPos = projectAndDivide(gbufferProjectionInverse, ndcPos);
    vec3 playerFeetPos = (gbufferModelViewInverse * vec4(veiwPos, 1.0)).xyz;
    vec3 shadowViewPos = (shadowModelView * vec4(playerFeetPos, 1.0)).xyz;
    vec3 shadowNdcPos = projectAndDivide(shadowProjection, shadowViewPos);
    shadowNdcPos.xyz = distort(shadowNdcPos.xyz);
    float bias = computeBias(shadowNdcPos);
    vec3 shadowScreenPos = shadowNdcPos * 0.5 + 0.5;
    shadowScreenPos.z -= bias;
	float sampleDepth = texture2D(shadowtex0, shadowScreenPos.xy).r;
    float shadowIntensity = step(sampleDepth, shadowScreenPos.z);
    
    if (depth == 1.0 ){
        shadowIntensity = 0.0;
    }

    /* DRAWBUFFERS:4 */
	gl_FragData[0] = vec4(shadowIntensity, shadowIntensity, shadowIntensity, 1.0);
}

#endif
#ifdef VERTEX_SHADER

varying vec2 tex_coords;

void main() {
	gl_Position = ftransform();
    tex_coords = gl_MultiTexCoord0.st;
}

#endif