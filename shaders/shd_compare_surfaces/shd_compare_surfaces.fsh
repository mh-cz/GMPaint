varying vec2 v_vTexcoord;

uniform sampler2D img1;
uniform sampler2D img2;

void main()
{
    gl_FragColor = (texture2D(img1, v_vTexcoord).r != texture2D(img2, v_vTexcoord).r) ? vec4(1., 0., 0., 1.) : vec4(0., 1., 0., 1.);
}
