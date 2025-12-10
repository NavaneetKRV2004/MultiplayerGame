shader_type spatial;

// Varyings
varying smooth float normal_y;
varying smooth float vertex_y;
uniform float height;
uniform float offset;
uniform sampler2D gradient;




void vertex() {
normal_y=NORMAL.y;
vertex_y=VERTEX.y;

}

void fragment()
{

		ALBEDO=texture(gradient,vec2(vertex_y/height+offset,0.0)).xyz;
}
