#include "/libs/settings.glsl"

#ifdef FRAGMENT_SHADER

uniform sampler2D lightmap;
uniform sampler2D texture;

uniform vec3 sunPosition;
uniform vec3 moonPosition;

varying vec2 lm_coords;
varying vec2 tex_coords;
varying vec4 frag_color;
varying vec4 normal_vec;

void main() {
	vec4 color = texture2D(texture, tex_coords) * frag_color;
	color.xyz = pow(color.xyz, vec3(GAMMA_MULTIPLIER));
	color *= texture2D(lightmap, lm_coords).x;
	color += vec3(1.0, 0.95, 0.9) * max(dot(normal_vec.xyz, normalize(sunPosition)), 0.0);
    color.xyz *= HDR_MULTIPLIER;

    /* DRAWBUFFERS:0 */
	gl_FragData[0] = color;
}

#endif
#ifdef VERTEX_SHADER

varying vec2 lm_coords;
varying vec2 tex_coords;
varying vec4 frag_color;
varying vec4 normal_vec;

uniform mat4 gbufferModelView;

void main() {
	gl_Position = ftransform();
	tex_coords = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lm_coords  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	frag_color = gl_Color;
	normal_vec.xyz = gl_Normal;
	normal_vec.w = 0.0;
}

#endif