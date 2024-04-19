uniform int worldTime;

const float pi = 3.141526;

const float third = 1/3;
const float three_over_two = 3/2;

//CYAN EMBER//
float sky_brightness() {
    float squareWave = 0.5 * (sin(pi/12000.0*(float(worldTime)+500.0))/sin(pi/8.0) + 1.0);
    return clamp(squareWave, 0, 1);
}

float sunset_brightness() {
    float sky_brightness = sky_brightness();
    float sunset_brightness = (sky_brightness * 2) - 1;
    return abs(sunset_brightness);
}

float sun_fall_off(float x) {
    float falloff = (x-1.0)*200.0;
    falloff = pow(1.02209, falloff);
    falloff -= 0.0127;
    return falloff;
}

float shadow_value(){
    float shadow_value = sunset_brightness();
    shadow_value = clamp(shadow_value - (third), 0.0, 1.0);
    return clamp(shadow_value * three_over_two, 0.0, 1.0);
}