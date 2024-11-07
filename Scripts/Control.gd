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
	data.removed.connect(_remove_qubit)
	data.gate_removed.connect(_on_gate_delete)
	data.gates_reordered.connect(_on_gate_reorder)

func _arrow_set_color(color: Array):
	arrow.set_color(color)

func _on_gate_added(gate: Gate):
	gates.push_back(gate)

func _on_gate_delete(gate: Gate):
	gates.erase(gate)

func _remove_qubit():
	if arrow:
		arrow.queue_free()

func _on_gate_reorder(new_order: Array[Gate]):
	gates = new_order
