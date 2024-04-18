#include "/libs/settings.glsl"

#ifdef FRAGMENT_SHADER

#include "/libs/tonemap_func.glsl"

uniform sampler2D colortex0;
varying vec2 tex_coords;

void main() {
	vec4 color = texture2D(colortex0, tex_coords);

#if TONEMAPPER == TONE_ACES
	color.xyz = aces(color.xyz);
#elif TONEMAPPER == TONE_REINHARD
	color.xyz = reinhard(color.xyz);
#elif TONEMAPPER == TONE_REINHARD_TWO
	color.xyz = reinhard2(color.xyz);
#elif TONEMAPPER == TONE_UNREAL
	color.xyz = unreal(color.xyz);
#elif TONEMAPPER == TONE_FILMIC
	color.xyz = filmic(color.xyz);
#elif TONEMAPPER == TONE_UNCHARTED_TWO
	color.xyz = uncharted2(color.xyz);
#elif TONEMAPPER == TONE_AGX
	#error TONE_AGX is not yet supported!
#elif TONEMAPPER == TONE_TATSU
	color.xyz = tatsu(color.xyz);
#elif TONEMAPPER == TONE_WHYFENCE
	color.xyz = whyfence(color.xyz);
#elif TONEMAPPER == TONE_WHYFENCE_ACES
	vec3 color_fence = whyfence(color.xyz);
	vec3 color_aces = aces(color.xyz);
	color.xyz = mix(color_fence, color_aces, 0.4);
#else
	#error TONEMAPPER is set to an invalid value. If you have no idea how this occured then contact the shader developer. Valid backend values are: TONE_ACES TONE_REINHARD TONE_REINHARD_TWO TONE_UNREAL TONE_FILMIC TONE_UNCHARTED_TWO
#endif

#if TONEMAPPER != TONE_UNREAL
	color.xyz = pow(color.xyz, vec3(1/GAMMA_MULTIPLIER));
#endif

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