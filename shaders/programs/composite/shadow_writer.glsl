#include "/libs/settings.glsl"

#ifdef FRAGMENT_SHADER

#include "/libs/project_divide.glsl"
#include "/libs/distort.glsl"

uniform sampler2D shadowtex0;
uniform sampler2D depthtex0;

uniform sampler2D colortex3;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowProjectionInverse;

varying vec2 tex_coords;

uniform vec3 shadowLightPosition;

void main() {
    float ndotl = dot(texture2D(colortex3, tex_coords).xyz, shadowLightPosition);

    float shadow_intensity = 0.0;
    float depth = 1.0;

    if (ndotl > 0){
        depth = texture(depthtex0, tex_coords).r;
        vec3 screen_pos = vec3(tex_coords, depth);
        vec3 ndc_pos = screen_pos * 2 - 1;
        vec3 veiw_pos = projectAndDivide(gbufferProjectionInverse, ndc_pos);
        vec3 player_feet_pos = (gbufferModelViewInverse * vec4(veiw_pos, 1.0)).xyz;
        vec3 shadow_view_pos = (shadowModelView * vec4(player_feet_pos, 1.0)).xyz;
        vec3 shadow_ndc_pos = projectAndDivide(shadowProjection, shadow_view_pos);
        shadow_ndc_pos.xyz = distort(shadow_ndc_pos.xyz);
        float bias = computeBias(shadow_ndc_pos);
        vec3 shadow_screen_pos = shadow_ndc_pos * 0.5 + 0.5;
        shadow_screen_pos.z -= bias;
        float sample_depth = texture2D(shadowtex0, shadow_screen_pos.xy).r;
        shadow_intensity = step(sample_depth, shadow_screen_pos.z);
    }

    if (depth == 1.0 ){
        shadow_intensity = 0.0;
    }

    /* DRAWBUFFERS:4 */
	gl_FragData[0] = vec4(shadow_intensity, 0.0, 0.0, 1.0);
}

#endif
#ifdef VERTEX_SHADER

varying vec2 tex_coords;

void main() {
	gl_Position = ftransform();
    tex_coords = gl_MultiTexCoord0.st;
}

#endif