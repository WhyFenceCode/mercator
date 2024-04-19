#include "/libs/settings.glsl"

#ifdef FRAGMENT_SHADER

/*
const bool colortex0MipmapEnabled = true;
*/

#include "/libs/tonemap_func.glsl"
#include "/libs/auto_exposure.glsl"

uniform sampler2D colortex0;
uniform sampler2D colortex5;

uniform float viewWidth;
uniform float viewHeight;
varying vec2 tex_coords;

void main() {
	vec4 average_color = texture2DLod(colortex0, vec2(0.5), log2(max(viewWidth, viewHeight)));
	vec4 color = texture2D(colortex0, tex_coords);

	float old_luminance = texture2D(colortex5, tex_coords).r;
	float luminance = luminance(average_color.rgb);
	luminance = mix(old_luminance, luminance, 0.000001);
	float multiplier_value = 0.0;
	if(texture2D(colortex5, tex_coords).b != 0.0) {
    	multiplier_value = key_value(mix(old_luminance, luminance, 0.00001));
	} else {
		multiplier_value = key_value(luminance);
		luminance = 1.0;
	}
    color.xyz *= multiplier_value;

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
	#error TONEMAPPER is set to an invalid value.
#endif

#if TONEMAPPER != TONE_UNREAL
	color.xyz = pow(color.xyz, vec3(1/GAMMA_MULTIPLIER));
#endif
	//gl_FragData[0] = color;

    /* DRAWBUFFERS:05 */
	gl_FragData[0] = vec4(vec3(luminance), 1.0);
	gl_FragData[1] = vec4(vec3(luminance, luminance, 1.0), 1.0);
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