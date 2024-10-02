shader_type spatial;
render_mode unshaded;
render_mode cull_disabled;

uniform float lineCountLong = 20.0f;
uniform float lineCountLat = 20.0f;
uniform float widthLong = 0.045f;
uniform float widthLat = 0.1f;
uniform float corrigation = 0.5f;
uniform float alphaLimit = 0.7f;
uniform float backgroundAlpha = 0.1f;
uniform vec3 lineColor: source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 backgroundColor: source_color = vec3(1.0, 1.0, 1.0);

void fragment() {
	//TODO: AA
	float latJump = 1.0f - widthLat;
	float latAlpha = step(latJump, mod(UV.y * lineCountLat - widthLat/2.0f, 1.0f));

	//TODO: hammer longitude
	float longJump = sqrt(1.0f - corrigation * pow((abs(UV.y - 0.5f) * 2.0f), 2.0f)) * widthLong;
	float longAlpha = step(longJump, mod(UV.x - 0.5f * widthLong, 1.0f / lineCountLong));

	ALPHA = (backgroundAlpha + step(0.5f, longAlpha + latAlpha)) * alphaLimit;
	vec3 background = (backgroundColor * (alphaLimit - ALPHA));
	vec3 line = step(alphaLimit / 2.0f, ALPHA - backgroundAlpha) * lineColor;

	ALBEDO = background + line;
}
