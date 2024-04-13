#version 120

#include "/libs/settings.glsl"

varying vec2 tex_coords;

uniform sampler2D colortex0;

void main() {
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4(texture(colortex0, tex_coords));

}