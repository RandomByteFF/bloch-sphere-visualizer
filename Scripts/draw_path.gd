extends Node
class_name PathDrawn

@export var line_radius = 0.3
@export var res = 200.0

func set_path(curve : Curve3D):
	$Path3D.curve = curve

func _ready():
	var circle = PackedVector2Array()

	var angle = 0.0
	var diff = 2 * PI / res

	while angle < 2 * PI:
		var scaled = Vector2(cos(angle), sin(angle) ) * line_radius
		angle += diff

		circle.append(scaled)
	$CSGPolygon3D.polygon = circle

func set_color(color : Array, percentage : float = 1.0):
	$CSGPolygon3D.material.set_shader_parameter("color", Vector3(color[0], color[1], color[2]) * percentage)
	$CSGPolygon3D.material.set_shader_parameter("alpha", color[3])
