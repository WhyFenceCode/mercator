#include "/libs/settings.glsl"

#ifdef FRAGMENT_SHADER

#include "/libs/depth_aware_blur.glsl"
#include "/libs/sky_data.glsl"

uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;

uniform sampler2D depthtex0;

uniform vec3 sunPosition;
uniform vec3 moonPosition;

varying vec2 tex_coords;

void main() {
	vec3 normal = texture2D(colortex3, tex_coords).xyz;

	vec3 lm_blur = da_blur(tex_coords, colortex2, depthtex0, 2, 0.1);
	vec3 lm_blur_hdr = lm_blur * lm_blur * lm_blur;
	lm_blur_hdr *= HDR_MULTIPLIER;

	vec4 color = texture2D(colortex1, tex_coords);
	color.xyz = pow(color.xyz, vec3(GAMMA_MULTIPLIER));
	vec4 output_color = color * lm_blur_hdr.x;

	float shadow_intensity = texture2D(colortex4, tex_coords).r;
	shadow_intensity = mix(1.0, shadow_intensity, sky_brightness());

	output_color.xyz = mix(output_color.xyz, vec3(SHADOW_COLOR_R, SHADOW_COLOR_G, SHADOW_COLOR_B), shadow_intensity/SHADOW_AMBIENCE);

	/* DRAWBUFFERS:0 */
	gl_FragData[0] = output_color;
}

#endif
#ifdef VERTEX_SHADER

varying vec2 tex_coords;

void main() {
	gl_Position = ftransform();
    tex_coords = gl_MultiTexCoord0.st;
}

#endif
