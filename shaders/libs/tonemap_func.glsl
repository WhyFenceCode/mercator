//Narkowicz 2015, "ACES Filmic Tone Mapping Curve"
vec3 aces(vec3 x) {
  const float a = 2.51;
  const float b = 0.03;
  const float c = 2.43;
  const float d = 0.59;
  const float e = 0.14;
  return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
}

//Erik Reinhard: https://github.com/dmnsgn/glsl-tone-map/blob/main/reinhard.glsl
vec3 reinhard(vec3 x) {
  return x / (1.0 + x);
}

//Erik Reinhard: https://github.com/dmnsgn/glsl-tone-map/blob/main/reinhard2.glsl
vec3 reinhard2(vec3 x) {
  const float L_white = 4.0;

  return (x * (1.0 + x / (L_white * L_white))) / (1.0 + x);
}

//Capt Tatsu Suggestion
vec3 tatsu(vec3 x) {
  return x/sqrt(x*x+1);
}

//Source not found: https://github.com/dmnsgn/glsl-tone-map/blob/main/unreal.glsl
vec3 unreal(vec3 x) {
  return x / (x + 0.155) * 1.019;
}

//Jace Regenbrecht https://github.com/dmnsgn/glsl-tone-map/blob/main/uncharted2.glsl
vec3 uncharted2_tonemap(vec3 x) {
  float A = 0.15;
  float B = 0.50;
  float C = 0.10;
  float D = 0.20;
  float E = 0.02;
  float F = 0.30;
  float W = 11.2;
  return ((x * (A * x + C * B) + D * E) / (x * (A * x + B) + D * F)) - E / F;
}

vec3 uncharted2(vec3 color) {
  const float W = 11.2;
  float exposureBias = 2.0;
  vec3 curr = uncharted2_tonemap(exposureBias * color);
  vec3 whiteScale = 1.0 / uncharted2_tonemap(vec3(W));
  return curr * whiteScale;
}

//John Hable: http://filmicworlds.com/blog/filmic-tonemapping-operators/
vec3 filmic(vec3 x) {
  vec3 X = max(vec3(0.0), x - 0.004);
  vec3 result = (X * (6.2 * X + 0.5)) / (X * (6.2 * X + 1.7) + 0.06);
  return pow(result, vec3(2.2));
}

//WhyFencePost: 
vec3 whyfence(vec3 x) {
  vec3 output_color = 1-exp((-1-atan(pow(x, 2-sqrt(x)))+(floor(x)/30))*x);
  return output_color;
}