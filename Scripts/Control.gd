class_name QubitControl

signal invalid_qubit

var arrow: Arrow
var qubit: Qubit = Qubit.ket_0
var gates : Array[Gate] = []
var interpolation : Array[Curve3D] = []

static var _arrow_scene := load("res://Scenes/arrow.tscn")

func _init(data: QubitGui, sphere: Node3D):
	arrow = _arrow_scene.instantiate()
	sphere.add_child(arrow)

	data.color_changed.connect(_arrow_set_color)
	data.gate_added.connect(_on_gate_added)
	data.gates_reordered.connect(_on_gate_reorder)
	data.gate_changed.connect(_on_gate_change)
	data.gate_removed.connect(_on_gate_delete)
	data.removed.connect(_remove_qubit)
	data.qubit_changed.connect(_on_qubit_change)
	_update_arrow()

func _arrow_set_color(color: Array):
	arrow.set_color(color)

func _on_gate_added(gate: Gate):
	gates.push_back(gate)
	_update_arrow()

func _on_gate_reorder(new_order: Array[Gate]):
	gates = new_order
	_update_arrow()

func _on_gate_change():
	_update_arrow()

func _on_gate_delete(gate: Gate):
	gates.erase(gate)
	_update_arrow()

func _remove_qubit():
	if arrow:
		arrow.queue_free()

func _on_qubit_change(re1: String, im1: String, re2: String, im2: String):
	#TODO: ExpressionHandler handler = ... 
	var x := Complex.new(re1.to_float(), im1.to_float())
	var y := Complex.new(re2.to_float(), im2.to_float())
	var new_value = Qubit.new(x, y)

	if new_value.is_valid():
		qubit = new_value
		_update_arrow()
	else:
		invalid_qubit.emit("|a|^2 + |b|^2 must be 1")
		#TODO: Hajrá Benedek - create warning (but the input field would call this on every change so be careful)

## Updates the arrow position
func _update_arrow():
	# copy the qubit
	var q := Qubit.new(qubit.x, qubit.y)
	
	# apply the gates
	var gate_length = gates.size()
	interpolation.resize(gate_length)

	for i in range(gate_length):
		var calculated = gates[i].interpolate(q)

		interpolation[i] = calculated["curve"]
		q = calculated["position"]

	arrow.set_point(q.to_bloch_spehere_pos())