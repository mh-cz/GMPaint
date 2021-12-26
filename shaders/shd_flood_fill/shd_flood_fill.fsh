varying vec2 v_vTexcoord;

uniform sampler2D img;
uniform vec2 start_pos;
uniform vec2 texel_size;
uniform vec4 start_col;
uniform float tolerance;

float get_brightness(vec3 RGB)
{
	return RGB.r * 0.33 + RGB.g * 0.5 + RGB.b * 0.16;
}

bool ok_tol(vec4 c1, vec4 c2, float tol) {
	return !(c1.r > c2.r+tol || c1.r < c2.r-tol
		  || c1.g > c2.g+tol || c1.g < c2.g-tol
		  || c1.b > c2.b+tol || c1.b < c2.b-tol
		  || c1.a > c2.a+tol || c1.a < c2.a-tol);
}

bool is_around() {
	
	bool is = false;
	for(float i = 0.; i < 2.; i++) {
		if(texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.,  texel_size.y * i)).r != 0. ||
		   texture2D(gm_BaseTexture, v_vTexcoord + vec2(0., -texel_size.y * i)).r != 0. ||
		   texture2D(gm_BaseTexture, v_vTexcoord + vec2( texel_size.x * i, 0.)).r != 0. ||
		   texture2D(gm_BaseTexture, v_vTexcoord + vec2(-texel_size.x * i, 0.)).r != 0.) {
			   is = true;
			   break;
		   }
	}
	return is;
}

void main()
{
	vec4 c = vec4(0.);
	vec4 img_col = texture2D(img, v_vTexcoord);
	
	if (texture2D(gm_BaseTexture, v_vTexcoord).r != 0. || (ok_tol(img_col, start_col, tolerance) && is_around()))
	{
		float br = get_brightness(img_col.rgb);
		c = vec4(vec3(br), img_col.a);
	}
	
    gl_FragColor = c;
}
