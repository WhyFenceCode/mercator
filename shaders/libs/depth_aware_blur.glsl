uniform float viewWidth;
uniform float viewHeight;

vec3 da_blur(vec2 tex_coords, sampler2D c_tex, sampler2D d_tex, int iteration, float cutoff) {
    float move_x = 1/viewWidth;
    float move_y = 1/viewHeight;

    int denominator = 4;

    float point_depth = texture2D(d_tex, tex_coords).x;

    vec3 color = texture2D(c_tex, tex_coords).xyz * 4;

    for(int j = 0; j < iteration*2; j++){
        int set = -iteration + j;
        float offset_x = move_x * float(set);
        vec2 pos = tex_coords + vec2(offset_x, 0);

        float new_depth = texture2D(d_tex, pos).x;
        float depth_change = abs(point_depth - new_depth);

        if (depth_change < cutoff) {
            color += texture2D(c_tex, pos).xyz;
            denominator ++;
        }
    }

    for(int j = 0; j < iteration*2; j++){
        int set = -iteration + j;
        float offset_y = move_y * float(set);
        vec2 pos = tex_coords + vec2(offset_y, 0);

        float new_depth = texture2D(d_tex, pos).x;
        float depth_change = abs(point_depth - new_depth);

        if (depth_change < cutoff) {
            color += texture2D(c_tex, pos).xyz;
            denominator ++;
        }
    }

    return color / float(denominator);
}