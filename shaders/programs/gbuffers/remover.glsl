#ifdef FRAGMENT_SHADER

void main() {
	discard;
}

#endif
#ifdef VERTEX_SHADER

void main() {
	gl_Position = vec4(-1.0);
}

#endif