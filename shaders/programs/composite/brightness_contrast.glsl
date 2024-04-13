#include "/libs/settings.glsl"

#ifdef FRAGMENT_SHADER

varying vec2 TexCoords;
uniform sampler2D colortex0;

const float ambientOcclusionLevel = AMBIENT_OCCLUSION;

void main(){
    vec4 basecolor = texture2D(colortex0, TexCoords);

    basecolor.r += WARMTH;
    basecolor.b -= WARMTH;
    clamp(basecolor, 0, 1);

    vec4 albedo = CONTRAST * (basecolor - vec4(0.5, 0.5, 0.5, 0)) + 0.5 + BRIGHTNESS;
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = albedo;
}

#endif
#ifdef VERTEX_SHADER

varying vec2 TexCoords;

void main() {
    gl_Position = ftransform();
    TexCoords = gl_MultiTexCoord0.st;
}

#endif