#include "/libs/settings.glsl"
#include "/libs/depth_aware_blur.glsl"

#ifdef FRAGMENT_SHADER

uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;

uniform sampler2D depthtex0;

uniform vec3 sunPosition;
uniform vec3 moonPosition;

varying vec2 tex_coords;

void main() {
	vec3 normal = texture2D(colortex3, tex_coords).xyz;

	vec3 lm_blur = da_blur(tex_coords, colortex2, depthtex0, 2, 0.1) * HDR_MULTIPLIER;

	vec4 color = texture2D(colortex1, tex_coords);
	color.xyz = pow(color.xyz, vec3(GAMMA_MULTIPLIER));
	vec4 output_color = color * lm_blur.x;

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
