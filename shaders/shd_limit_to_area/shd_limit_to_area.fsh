varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D area;

void main()
{
	vec4 area_c = texture2D(area, v_vTexcoord);
    vec4 c = texture2D(gm_BaseTexture, v_vTexcoord);
	gl_FragColor = vec4(c.rgb, c.a * area_c.a);
}
