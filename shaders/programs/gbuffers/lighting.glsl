#include "/libs/settings.glsl"

#ifdef FRAGMENT_SHADER

uniform sampler2D lightmap;
uniform sampler2D texture;

uniform vec3 sunPosition;
uniform vec3 moonPosition;

varying vec2 lm_coords;
varying vec2 tex_coords;
varying vec4 frag_color;

void main() {
	vec4 color = texture2D(texture, tex_coords) * frag_color;
	color *= texture2D(lightmap, lm_coords);
	color.xyz = pow(color.xyz, vec3(GAMMA_MULTIPLIER));
    color.xyz *= HDR_MULTIPLIER;

    /* DRAWBUFFERS:0 */
	gl_FragData[0] = color;
}

#endif
#ifdef VERTEX_SHADER

varying vec2 lm_coords;
varying vec2 tex_coords;
varying vec4 frag_color;

uniform mat4 gbufferModelView;

void main() {
	gl_Position = ftransform();
	tex_coords = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lm_coords  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	frag_color = gl_Color;
}

#endif