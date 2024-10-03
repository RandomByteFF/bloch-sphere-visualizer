extends Camera3D

@export var sensitivity := 0.01
@export var target: Node3D
@export var pivot: Node3D

var _left_click_pressed = false

func _ready() -> void:
	pass	

func _process(_delta: float) -> void:
	pass
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			_left_click_pressed = event.pressed
	if event is InputEventMouseMotion && _left_click_pressed:
		var delta = event.relative * sensitivity
		pivot.rotation.y = (pivot.rotation.y - delta.x)
		pivot.rotation.x = (pivot.rotation.x - delta.y)
		pivot.rotation.x = clamp(pivot.rotation.x, -PI/2, PI/2)
