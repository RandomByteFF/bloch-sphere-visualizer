shader_type spatial;
render_mode cull_back;

void fragment() {
	float s = mod(UV.x, 0.1f);
	float m = abs(UV.y - 0.5f) * 2.0f * 0.09f;
	ALPHA = 0.1f + step(0.09f - m, s);
}
