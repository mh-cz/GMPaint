varying vec2 v_vTexcoord;

uniform vec2 texel_size;

void main()
{	
	if (v_vTexcoord.x < texel_size.x && v_vTexcoord.y < texel_size.y) {
		for(float u = 0.; u < 1.; u += texel_size.x) {
			for(float v = 0.; v < 1.; v += texel_size.y) {
				if (texture2D(gm_BaseTexture, vec2(u, v)).r == 1.) {
					gl_FragColor = vec4(1., 0., 0., 1.);
					break;
				}
			}
		}
	}
}
