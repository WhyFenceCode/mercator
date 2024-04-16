#include "/libs/settings.glsl"

#ifdef FRAGMENT_SHADER

uniform sampler2D lightmap;
uniform sampler2D texture;

varying vec2 lm_coords;
varying vec2 tex_coords;
varying vec4 frag_color;
varying vec3 normal_vec;

void main() {
	vec4 color = texture2D(texture, tex_coords) * frag_color;
	vec4 lm = texture2D(lightmap, lm_coords);
	vec4 normal = vec4(normal_vec, 0);

    /* DRAWBUFFERS:1234 */
	gl_FragData[0] = color;
	gl_FragData[1] = lm;
	gl_FragData[2] = normal;
}

#endif
#ifdef VERTEX_SHADER

varying vec2 lm_coords;
varying vec2 tex_coords;
varying vec4 frag_color;
varying vec3 normal_vec;

uniform mat4 gbufferModelView;

void main() {
	gl_Position = ftransform();
	tex_coords = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lm_coords  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	frag_color = gl_Color;
	normal_vec.xyz = gl_Normal;
}

#endif