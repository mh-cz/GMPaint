varying vec2 v_vTexcoord;

uniform float fo;

void main()
{
	float d = distance(vec2(.5, .5), v_vTexcoord);
	float alpha = min(1., (1. - (.5 + d)) * (fo * fo));
    gl_FragColor = vec4(1. * alpha, 1. * alpha, 1. * alpha, alpha);
}
