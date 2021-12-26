varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D img;
uniform vec3 blend;

float get_brightness(vec3 RGB)
{
	return RGB.r * 0.33 + RGB.g * 0.5 + RGB.b * 0.16;
}

void main()
{
	vec4 mask_c = texture2D(gm_BaseTexture, v_vTexcoord);
	vec4 img_c = texture2D(img, v_vTexcoord);
	
	float br = get_brightness(img_c.rgb);
	
    gl_FragColor = vec4(img_c.rgb * br, mask_c.a);
}
