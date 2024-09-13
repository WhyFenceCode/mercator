#version 330 compatibility

uniform sampler2D colortex0;

in vec2 texcoord;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 color;

void main() {
	color = texture(colortex0, texcoord);
	color.rgb = vec3(dot(color.rgb, vec3(1.0/3.0)));
}
