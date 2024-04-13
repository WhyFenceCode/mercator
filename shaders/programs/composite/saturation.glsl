#include "/libs/settings.glsl"

#ifdef FRAGMENT_SHADER

#include "/libs/rgb_hsv.glsl"

varying vec2 TexCoords;
uniform sampler2D colortex0;

void main(){
    vec4 basecolor = texture2D(colortex0, TexCoords);
    basecolor = rgbToHsv(basecolor);
    basecolor.y = basecolor.y * SATURATION;

    vec4 albedo = hsvToRgb(basecolor);
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