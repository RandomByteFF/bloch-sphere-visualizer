shader_type spatial;
render_mode cull_back;

void fragment() {
	ALPHA = UV.x;
}
