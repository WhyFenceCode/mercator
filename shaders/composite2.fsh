#version 330 compatibility

uniform sampler2D colortex0;
uniform sampler2D mainColorGrade;

in vec2 texcoord;

vec4 colorGrade(vec4 color){
  return texture(mainColorGrade, vec3(color.x, color.y, color.z));
}

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 color;

void main() {
  color = texture(colortex0, texcoord);
}
