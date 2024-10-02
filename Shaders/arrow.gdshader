shader_type spatial;
render_mode unshaded;

uniform vec3 color: source_color = vec3(1.0, 1.0, 1.0);
uniform float alpha = 1.0f;

void fragment() {
	ALBEDO = color;
	ALPHA = alpha;
}
