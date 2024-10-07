extends Node3D
class_name Arrow

@export var model: MeshInstance3D

## Used the visually set the arrow towards the direction on the bloch-sphere
func set_point(point: Vector3) -> void:
	point = point.normalized()
	var up = Vector3(0, 1, 0)
	if (abs(point.y) >= 0.999):
		up = Vector3(1, 0, 0)
	basis = Basis.looking_at(point, up, true)

func set_color(color: Array):
	model.material_override.set_shader_parameter("color", Vector3(color[0], color[1], color[2]))
	model.material_override.set_shader_parameter("alpha", color[3])
