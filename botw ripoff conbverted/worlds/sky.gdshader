shader_type sky;

uniform sampler2D cube_atlas[5];
uniform int selected_sky;
uniform float time=0;
const vec2 cell_size = vec2(1.0 / 3.0, 1.0 / 2.0);

vec3 mix3(vec3 a,vec3 b,float c){
	return  a*c +b*(1.0-c);

}

vec2 cube_uv(vec3 dir, out int face_id) {
    vec3 abs_dir = abs(dir);
    float u, v;

    if (abs_dir.x >= abs_dir.y && abs_dir.x >= abs_dir.z) {
        if (dir.x > 0.0) {
            face_id = 2; // +X → Right top
            u = dir.z / abs_dir.x;
            v = -dir.y / abs_dir.x;
        } else {
            face_id = 4; // -X → Middle bottom
            u = -dir.z / abs_dir.x;
            v = -dir.y / abs_dir.x;
        }
    } else if (abs_dir.y >= abs_dir.x && abs_dir.y >= abs_dir.z) {
        if (dir.y > 0.0) {
            face_id = 1; // +Y → Middle top
            u = -dir.z / abs_dir.y;
            v = -dir.x / abs_dir.y;
        } else {
            face_id = 0; // -Y → Left top
            u = -dir.z / abs_dir.y;
            v = dir.x / abs_dir.y;
        }
    } else {
        if (dir.z > 0.0) {
            face_id = 3; // +Z → Left bottom
            u = -dir.x / abs_dir.z;
            v = -dir.y / abs_dir.z;
        } else {
            face_id = 5; // -Z → Right bottom
            u = dir.x / abs_dir.z;
            v = -dir.y / abs_dir.z;
        }
    }

    return vec2(u * 0.5 + 0.5, v * 0.5 + 0.5);
}

vec2 atlas_uv(vec2 face_uv, int face_id) {
    // Map face_id to grid position in the atlas
    int col = 0;
    int row = 0;

    if (face_id == 0) { col = 0; row = 0; } // -Y
    if (face_id == 1) { col = 1; row = 0; } // +Y
    if (face_id == 2) { col = 2; row = 0; } // +X
    if (face_id == 3) { col = 0; row = 1; } // +Z
    if (face_id == 4) { col = 1; row = 1; } // -X
    if (face_id == 5) { col = 2; row = 1; } // -Z

    vec2 base = vec2(float(col), float(row)) * cell_size;
    return base + face_uv * cell_size;
}

void sky() {

    vec3 dir = EYEDIR;
    int face_id;
    vec2 face_uv = cube_uv(dir, face_id);
	const float shrink = 0.999;
	face_uv = face_uv * shrink + (1.0 - shrink) * 0.5;

    vec2 uv = atlas_uv(face_uv, face_id);

	if (selected_sky==-1){
		vec3 color1=texture(cube_atlas[1], uv).rgb;
		vec3 color2=texture(cube_atlas[4], uv).rgb;
		vec3 color3=texture(cube_atlas[2], uv).rgb;

		float time1=time;

		if(time1>180.0)
		time1=360.0-time1;

		float percent=time1/180.0;
		if(percent>=0.0 && percent <=0.5)
		COLOR=mix3(color3,color1,percent);
		else
		COLOR=mix3(color1,color2,percent);
		}
	else{
	    vec3 color = texture(cube_atlas[clamp(selected_sky,0,4)], uv).rgb;
	    COLOR = color;
	}
}
