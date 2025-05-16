shader_type spatial;

// Varyings
varying flat float normal_y;
varying flat float vertex_y;
uniform sampler2D ft:filter_nearest;
uniform sampler2D gy:filter_nearest;




void vertex() {
normal_y=NORMAL.y;
vertex_y=VERTEX.y;

}

void fragment()
{
	if (normal_y>0.95){
		ALBEDO=texture(ft,UV*10.0).xyz;
		}
	else{
		ALBEDO=vec3(112,72,60)/256.0;
}
	}
	

	

