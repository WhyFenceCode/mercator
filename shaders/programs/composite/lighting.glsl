#include "/libs/settings.glsl"

#ifdef FRAGMENT_SHADER

uniform sampler2D colortex1;
uniform sampler2D colortex2;

varying vec2 tex_coords;

void main() {
	vec4 color = texture2D(colortex1, tex_coords);
	vec4 output_color = color * texture2D(colortex2, tex_coords).x;

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
