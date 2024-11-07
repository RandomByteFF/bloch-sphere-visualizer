class_name GateGui

signal delete_gate

var gate: Gate
var identifier: String
## Required because of popups need to be distinct
var _id: int

static var ids = ["X", "Y", "Z", "H", "P"]
static var _global_id = 0
static func _gateMap(id):
	match id:
		"X":
			return Gate.X
		"Y":
			return Gate.Y
		"Z":
			return Gate.Z
		"H":
			return Gate.H
		"P":
			return Gate.P()


@warning_ignore("shadowed_variable")
func _init(identifier: String):
	self.identifier = identifier
	gate = _gateMap(identifier)
	_id = _global_id
	_global_id += 1

func gui(clickable: bool = true):
	if ImGui.ButtonEx(identifier + "##" + str(_id), Vector2(40, 40)) && clickable:
		ImGui.OpenPopup("##gate_popup_" + str(_id))
	if ImGui.BeginPopup("##gate_popup_" + str(_id)):
		_custom_popup()
		if ImGui.Button("Delete gate"):
			delete_gate.emit(self)
		ImGui.EndPopup()

func _custom_popup():
	pass
