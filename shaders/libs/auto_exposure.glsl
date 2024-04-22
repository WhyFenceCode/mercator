#include "/libs/settings.glsl"

//From IMS
float luminance(vec3 rgb) {
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    return dot(rgb, W);
}

//Math from Knarkowicz: https://knarkowicz.wordpress.com/2016/01/09/automatic-exposure/
float key_value(float x){
    float key_value = 2.0 / ((log(x + 1.0) / log(10.0) + 2.0));
    return AUTOEXPOSURE_CONSTANT - key_value;
}