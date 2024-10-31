class_name QubitControl

var arrow: Arrow
var qubit: Qubit
var gates = []

static var _arrow_scene := load("res://Scenes/arrow.tscn")

func _init(data: QubitGui, sphere: Node3D):
	arrow = _arrow_scene.instantiate()
	sphere.add_child(arrow)
	data.color_changed.connect(_arrow_set_color)
	data.gate_added.connect(_on_gate_added)

func _arrow_set_color(color: Array):
	arrow.set_color(color)

func _on_gate_added(gate: Gate):
	gates.push_back(gate)
	print(gates)
