extends Node3D
class_name Arrow

@export var model: MeshInstance3D

func set_color(color: Array):
	model.material_override.set_shader_parameter("color", Vector3(color[0], color[1], color[2]))
	model.material_override.set_shader_parameter("alpha", color[3])
