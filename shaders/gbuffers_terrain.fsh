#version 330 compatibility

uniform sampler2D lightmap;
uniform sampler2D gtexture;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;
in vec3 normal;

/* DRAWBUFFERS:012 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 lightmapData;
layout(location = 2) out vec4 encodedNormal;


void main() {
	color = texture(gtexture, texcoord) * glcolor;
	if (color.a < 0.1) {
		discard;
	}
	color.rgb = pow(color.rgb, vec3(2.2));
	lightmapData = vec4(lmcoord, 0.0, 1.0);
	encodedNormal = vec4(normal * 0.5 + 0.5, 1.0);
}
