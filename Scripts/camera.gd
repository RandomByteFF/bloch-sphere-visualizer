extends Camera3D

@export var sensitivity := 0.01
@export var target: Node3D
@export var pivot: Node3D

var _prev_pos := Vector2()
var _click_pos := Vector2()

func _ready() -> void:
	pass	

func _process(_delta: float) -> void:
	_prev_pos = _click_pos
	if Input.is_action_pressed("left_click"):
		_click_pos = get_viewport().get_mouse_position()
		if Input.is_action_just_pressed("left_click"):
			_prev_pos = _click_pos
		var delta := (_click_pos - _prev_pos) * sensitivity
		pivot.rotation.y = (pivot.rotation.y - delta.x)
		pivot.rotation.x = (pivot.rotation.x - delta.y)
		pivot.rotation.x = clamp(pivot.rotation.x, -PI/2, PI/2)
