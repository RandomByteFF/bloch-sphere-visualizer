shader_type spatial;
render_mode cull_front;

void fragment() {
	float s = mod(UV.x, 0.1f);
	float m = abs(UV.y - 0.5f) * 0.01f;
	ALPHA = 0.1f + 1.0f - step(0.01f - m, s);
}
