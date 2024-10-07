class_name Gate

## Override this for other gates
var label = ""

func gui():
	ImGui.ButtonEx(label, Vector2(40, 40))