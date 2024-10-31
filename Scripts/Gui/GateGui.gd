class_name GateGui

var gate: Gate
var identifier: String

static var ids = ["X", "Y", "Z", "H", "P"]
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

func gui():
	ImGui.ButtonEx(identifier, Vector2(40, 40))
