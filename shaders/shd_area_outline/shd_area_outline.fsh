varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 texel_size;
uniform float time;

void main() {
	
	vec4 c = vec4(0.);
	
	if (texture2D(gm_BaseTexture, v_vTexcoord).a == 0.) {
	
		float v = texture2D(gm_BaseTexture, v_vTexcoord + vec2(texel_size.x, 0.)).a
				+ texture2D(gm_BaseTexture, v_vTexcoord - vec2(texel_size.x, 0.)).a 
				+ texture2D(gm_BaseTexture, v_vTexcoord + vec2(0., texel_size.y)).a
				+ texture2D(gm_BaseTexture, v_vTexcoord - vec2(0., texel_size.y)).a;
	
		if (v > 0.) {
			float k = mod(floor((fract(v_vTexcoord.x + v_vTexcoord.y)) * 50. - time), 2.);
			c = vec4(vec3(k), .75);
		}
	
	}
	
    gl_FragColor = c;
}
