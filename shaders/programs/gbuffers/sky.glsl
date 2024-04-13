#include "/libs/settings.glsl"

#ifdef OVERWORLD_SHADER

#ifdef FRAGMENT_SHADER

#include "/libs/fbm.glsl"
#include "/libs/skydata.glsl"

varying vec3 view_pos;
varying vec3 up_view_pos;
varying vec4 star_data;

uniform sampler2D colortex0;
uniform sampler2D sky_overworld_colors;
uniform sampler2D moon_colors;
uniform sampler2D sun_colors;

uniform vec3 sunPosition;
uniform vec3 moonPosition;

void main() {

    //DISCARD STARS//
    if (star_data.a > 0.5){
        discard;
    }

    //NORMALISE COORDS//
    vec3 view_pos_normal = normalize(view_pos);
    vec3 up_view_pos_normal = normalize(up_view_pos);

    vec3 sun_pos_normal = normalize(sunPosition);
    vec3 moon_pos_normal = normalize(moonPosition);

    //CREATE CUSTOM COORD SPACES//
    vec2 moon_coords = view_pos_normal.xy - moon_pos_normal.xy;
    moon_coords = moon_coords + vec2(0.1, 0.05);

    vec2 sun_coords = view_pos_normal.xy - sun_pos_normal.xy;

    //BACKGROUND HEIGHT MATH//
    float hight_dot = dot(view_pos_normal, up_view_pos_normal);
    hight_dot = hight_dot * 0.5 + 0.5;
    hight_dot = 1 - hight_dot;

    //DOT MATH//
    float sun_dot = dot(view_pos_normal, sun_pos_normal);
    float moon_dot = dot(view_pos_normal, moon_pos_normal);

    //BACKGROUND OUTPUT//
    vec3 output_color = texture(sky_overworld_colors, vec2(sky_brightness(), hight_dot)).xyz;

    //MOON MIXER MATH//
    float moon_dot_mid = clamp((moon_dot - 0.95)*20, 0.0, 1.0);
    moon_dot_mid = moon_dot_mid * moon_dot_mid * moon_dot_mid;
    moon_dot_mid = mix(moon_dot_mid, 0, sky_brightness());

    float moon_dot_min = clamp((moon_dot - 0.99)*90, 0.0, 1.0);
    moon_dot_min = moon_dot_min * moon_dot_min;
    moon_dot_min = mix(moon_dot_min, 0, sky_brightness());

    //SUN MIXER MATH//
    float sun_dot_main_minus = mix(0.96, 0.94, sky_brightness());
    float sun_dot_main_multi = mix(25.0, 17.0, sky_brightness());
    float sun_dot_main = clamp((sun_dot - sun_dot_main_minus)*sun_dot_main_multi, 0.0, 1.0);
    sun_dot_main = sun_fall_off(sun_dot_main);

    //SUNRISE MIXER MATH//
    float sun_dot_rise = abs(dot(view_pos_normal, up_view_pos_normal));
    sun_dot_rise = 1.0 - sun_dot_rise;
    sun_dot_rise *= 1.2;
    sun_dot_rise *= sun_dot_rise * sun_dot_rise;
    sun_dot_rise *= (1 - clamp(sunset_brightness(), 0.0, 1.0));
    sun_dot_rise *= sun_dot;
    sun_dot_rise = clamp(sun_dot_rise, 0, 1);

    //MOON Output//
    output_color = mix(output_color, texture(moon_colors, vec2(1.0, 1.0)).xyz, moon_dot_mid);
    output_color = mix(output_color, texture(moon_colors, vec2(0.0, 1.0)).xyz, moon_dot_min);

    if (moon_dot > 0.997) {
        float moon_main_mixer = fbm_noise(moon_coords);
        moon_main_mixer = moon_main_mixer * 1.5;
        vec3 moon_color = mix(texture(moon_colors, vec2(1.0, 0.0)).xyz, texture(moon_colors, vec2(0.0, 0.0)).xyz, moon_main_mixer);
        output_color = mix(output_color, moon_color, 0.95);
    }

    //SUN OUTPUT//
    output_color = mix(output_color, texture(sun_colors, vec2(0.0, 0.0)).xyz, sun_dot_rise); //Sun Rise
    output_color = mix(output_color, texture(sun_colors, vec2(0.0, 0.0)).xyz, sun_dot_main);

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4(output_color,  1.0) * HDR_MULTIPLIER;
}

#endif
#ifdef VERTEX_SHADER

varying vec3 view_pos;
varying vec3 up_view_pos;
varying vec4 star_data;

uniform mat4 gbufferModelView;

void main() {
    view_pos = (gl_ModelViewMatrix * gl_Vertex).xyz;

    vec3 up_world_pos = vec3(0.0, 1.0, 0.0);
    up_view_pos = (gbufferModelView * vec4(up_world_pos, 0.0)).xyz;

    star_data = vec4(gl_Color.rgb, float(gl_Color.r == gl_Color.g && gl_Color.g == gl_Color.b && gl_Color.r > 0.0));

    if (star_data.a > 0.5){
        gl_Position = vec4(-1.0);
    }

    gl_Position = ftransform();
}

#endif

#endif

#ifdef END_SHADER

#ifdef FRAGMENT_SHADER

varying vec3 view_pos;
varying vec3 up_view_pos;
varying vec4 star_data;

uniform sampler2D colortex0;
uniform sampler2D sky_end_colors;

void main() {
    //NORMALISE COORDS//
    vec3 view_pos_normal = normalize(view_pos);
    vec3 up_view_pos_normal = normalize(up_view_pos);

    //BACKGROUND HEIGHT MATH//
    float hight_dot = dot(view_pos_normal, up_view_pos_normal);
    hight_dot = hight_dot * 0.5 + 0.5;
    hight_dot = 1 - hight_dot;

    //BACKGROUND OUTPUT//
    vec3 output_color = texture(sky_end_colors, vec2(0.0, hight_dot)).xyz;

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4(output_color,  1.0) * HDR_MULTIPLIER;
}

#endif
#ifdef VERTEX_SHADER

varying vec3 view_pos;
varying vec3 up_view_pos;
varying vec4 star_data;

uniform mat4 gbufferModelView;

void main() {
    view_pos = (gl_ModelViewMatrix * gl_Vertex).xyz;

    vec3 up_world_pos = vec3(0.0, 1.0, 0.0);
    up_view_pos = (gbufferModelView * vec4(up_world_pos, 0.0)).xyz;

    star_data = vec4(gl_Color.rgb, float(gl_Color.r == gl_Color.g && gl_Color.g == gl_Color.b && gl_Color.r > 0.0));

    if (star_data.a > 0.5){
        gl_Position = vec4(-1.0);
    }

    gl_Position = ftransform();
}

#endif

#endif