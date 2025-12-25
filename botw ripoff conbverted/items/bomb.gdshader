shader_type spatial;

uniform vec4 col : source_color;
uniform float progress : hint_range(0.0, 1.0);

void fragment() {
    float freq = mix(1.0, 25.0, progress);

    float pulse ;
	pulse = progress!=0.0?(0.5 + 0.5 * sin(TIME*freq)):0.0;

    ALBEDO = col.rgb;
    ALPHA = pulse;
}
