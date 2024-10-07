extends Camera3D

@export var sensitivity := 0.01
@export var zoom_sensitivity := 0.05
@export var max_zoom_distance := 0.5
@export var min_zoom_distance := 5
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
		elif event.button_index == 4:
			position += -basis.z * zoom_sensitivity
		elif event.button_index == 5:
			position += basis.z * zoom_sensitivity
		# assuming sphere is in origin
		if position.length() < max_zoom_distance:
			position = position.normalized() * max_zoom_distance
		elif position.length() > min_zoom_distance:
			position = position.normalized() * min_zoom_distance

	if event is InputEventMouseMotion && _left_click_pressed:
		var delta = event.relative * sensitivity
		pivot.rotation.y = (pivot.rotation.y - delta.x)
		pivot.rotation.x = (pivot.rotation.x - delta.y)
		pivot.rotation.x = clamp(pivot.rotation.x, -PI/2, PI/2)
