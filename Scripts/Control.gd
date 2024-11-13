class_name QubitControl

signal invalid_qubit

var arrow: Arrow
var qubit: Qubit = Qubit.ket_0
var gates : Array[Gate] = []

var interpolation : Curve3D = Curve3D.new()
var path : PathDrawn

static var _arrow_scene := load("res://Scenes/arrow.tscn")
static var _path_scene := load("res://Scenes/path.tscn")

func _init(data: QubitGui, sphere: Node3D):
	arrow = _arrow_scene.instantiate()
	sphere.add_child(arrow)

	path = _path_scene.instantiate()
	sphere.add_child(path)

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
	path.set_color(color, 0.6)

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

func _on_qubit_change(text1 :String,  text2: String): 
	var x := ExpressionHandler.evaluate(text1)
	var y := ExpressionHandler.evaluate(text2)
	var new_value = Qubit.new(x, y)

	if new_value.is_valid():
		qubit = new_value
		_update_arrow()
	else:
		invalid_qubit.emit("|a|^2 + |b|^2 must be 1")
		#TODO: Hajrá Benedek - create warning (but the input field would call this on every change so be careful)

## Updates the arrow position
var points = []

func _update_arrow():
	# copy the qubit
	var q := Qubit.new(qubit.x, qubit.y)

	for point in points:
		point.queue_free()
	points.clear()
	
	# apply the gates
	var gate_length = gates.size()
	interpolation.clear_points()

	for i in range(gate_length):
		#if not gates[i].value._is_unitary():
		#	continue

		var calculated = gates[i].interpolate(q, true, 30)

		# add the curve points
		for point in calculated["curve_points"]:
			interpolation.add_point(point)

		q = calculated["position"]

	path.set_path(interpolation)

	# cause godot uses different coordinate system
	arrow.set_point(q.to_bloch_spehere_pos(true))
