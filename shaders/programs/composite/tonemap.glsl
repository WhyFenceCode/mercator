#include "/libs/settings.glsl"

#ifdef FRAGMENT_SHADER

#include "/libs/tonemap_func.glsl"

uniform sampler2D colortex0;
varying vec2 tex_coords;

void main() {
	vec4 color = texture2D(colortex0, tex_coords);
    color.xyz = aces(color.xyz);
	color.xyz = pow(color.xyz, vec3(1/GAMMA_MULTIPLIER));

    /* DRAWBUFFERS:0 */
	gl_FragData[0] = color;
}

#endif
#ifdef VERTEX_SHADER

varying vec2 tex_coords;

uniform mat4 gbufferModelView;

void main() {
	gl_Position = ftransform();
	tex_coords = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}

#endif