//BOOK OF SHADERS//

const int octaves = 8;

float hash_value(vec2 sample_pos, float scale_factor)
{
	sample_pos = mod(sample_pos, scale_factor);
	return fract(sin(dot(sample_pos, vec2(27.16898, 38.90563))) * 5151.5473453);
}

float perlin_noise(vec2 sample_pos, float scale_factor)
{
	vec2 fractional_parts;
	
	sample_pos *= scale_factor;
	
	fractional_parts = fract(sample_pos);
    sample_pos = floor(sample_pos);
	
    fractional_parts = fractional_parts*fractional_parts*(3.0-2.0*fractional_parts);
	
    float res = mix(mix(hash_value(sample_pos, 				 scale_factor),
						hash_value(sample_pos + vec2(1.0, 0.0), scale_factor), fractional_parts.x),
					mix(hash_value(sample_pos + vec2(0.0, 1.0), scale_factor),
						hash_value(sample_pos + vec2(1.0, 1.0), scale_factor), fractional_parts.x), fractional_parts.y);
    return res;
}


float fbm_noise(vec2 sample_pos)
{
	float current_noise_density = 0.0;
	float scale_factor = 10.0;
    sample_pos = mod(sample_pos, scale_factor);
	float amplitude = 0.6;
	
	for (int i = 0; i < 5; i++)
	{
		current_noise_density += perlin_noise(sample_pos, scale_factor) * amplitude;
		amplitude *= 0.5;
		scale_factor *= 2.;
	}
	return min(current_noise_density, 1.0);
}
