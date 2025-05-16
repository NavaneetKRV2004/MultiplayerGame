shader_type spatial;


uniform vec4 col:source_color;
uniform float freq:hint_range(0,100);
void fragment() {
	vec4 col2=col;
	float freq2=freq;
	ALBEDO=col.xyz;
ALPHA=1.0*sin(freq2*TIME);
}
