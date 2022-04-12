varying vec2 v_vTexcoord;

uniform float v;

#define TWO_PI 6.28318530718

vec3 hsv2rgb(vec3 c)
{
    vec3 RGB = clamp(abs(mod(c.x * 6.0 + vec3(0.0,4.0,2.0), 6.0)-3.0)-1.0, 0.0, 1.0);
    RGB = RGB * RGB * (3.0 - 2.0 * RGB);
    return c.z * mix(vec3(1.0), RGB, c.y);
}

void main()
{
	float alpha = 0.;
    vec3 color = vec3(0.);

    vec2 toCenter = vec2(0.5) - v_vTexcoord;
	float radius = length(toCenter) * 2.0;
	
	if (radius < 1.) {
	    float angle = atan(toCenter.y, toCenter.x);
	    color = hsv2rgb(vec3((angle/TWO_PI) + 0.5, radius, v));
		alpha = 1.;
	}

    gl_FragColor = vec4(color, alpha);
}
