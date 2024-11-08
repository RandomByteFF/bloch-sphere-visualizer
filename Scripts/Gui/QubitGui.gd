class_name QubitGui

signal color_changed
signal gate_added
signal gate_removed
signal removed
signal gates_reordered
signal qubit_changed

var _re_text1 = ["1"]
var _im_text1 = ["0"]
var _re_text2 = ["0"]
var _im_text2 = ["0"]

var bit_index := 0
var color_picker_open = false
var identifier := "a"
var main_gui: Gui
## Default arrow color. The length has to be 4, else ImGui will crash the application
## without any error whatsoever. 
var color = [0.0, 0.0, 0.0, 1.0]
var gates: Array[GateGui] = []

var _init_mouse_pos := Vector2()
var _hold_on_prev_frame = false
var _selected_gate: GateGui

# Trust me bro
@warning_ignore("shadowed_variable")
func _init(main_gui: Gui) -> void:
	self.main_gui = main_gui

func gui():
	ImGui.BeginChild("qubit_gui_" + str(bit_index), Vector2(0, 0), ImGui.ChildFlags_AutoResizeY)
	
	# Identifier text
	ImGui.AlignTextToFramePadding()
	ImGui.Text("|" + identifier + ">")
	ImGui.SameLine()

	if ImGui.ColorButton("##arrow_color_button", Color(color[0], color[1], color[2], color[3])):
		color_picker_open = !color_picker_open
	ImGui.SameLine()

	# Complex number 1
	ImGui.PushItemWidth(80)
	if ImGui.InputText("##re_text_1", _re_text1, 40):
		_on_qubit_change()
	ImGui.SameLine()
	if ImGui.InputText("##im_text_1", _im_text1, 40):
		_on_qubit_change()
	ImGui.SameLine()
	ImGui.PopItemWidth()
	ImGui.Text("i")

	#Complex number 2
	ImGui.PushItemWidth(80)
	
	if ImGui.Button("Del"):
		removed.emit()
		main_gui.remove_qubit(self)
	ImGui.SameLine()

	# ImGui is a piece of shit, but oddly, it's really useful sometimes
	# (I still love it tho)
	ImGui.SetCursorPosX(56)
	if ImGui.InputText("##re_text_2", _re_text2, 40):
		_on_qubit_change()
	ImGui.SameLine()
	if ImGui.InputText("##im_text_2", _im_text2, 40):
		_on_qubit_change()
	ImGui.SameLine()
	ImGui.PopItemWidth()
	ImGui.Text("i")

	# Color picker (if color picker is open)
	if color_picker_open:
		if ImGui.ColorPicker4("##Arrow color", color, ImGui.ColorEditFlags_NoSidePreview | ImGui.ColorEditFlags_NoSmallPreview):
			color_changed.emit(color)
	
	ImGui.BeginChild("gates", Vector2(0, 70), ImGui.ChildFlags_Border, ImGui.WindowFlags_HorizontalScrollbar)
	# TODO: Refactor, this is ugly because godot imgui doesn't support drag-drop payloads
	var it = 0
	var try_switch = false
	var c_pos: float
	var s_index = 0
	var clickable = true
	var _cursor_poses: Array[float] = []
	_cursor_poses.resize(gates.size())

	for i in gates:
		_cursor_poses[it] = ImGui.GetCursorPosX()
		var d = Vector2()
		if i == _selected_gate:
			d = main_gui.get_viewport().get_mouse_position() - _init_mouse_pos
			ImGui.SetCursorPosX(ImGui.GetCursorPosX() + d.x)
			try_switch = true
			c_pos = ImGui.GetCursorPosX()
			s_index = it
			clickable = false

		i.gui(clickable)
		ImGui.SameLine()
		if i == _selected_gate:
			ImGui.SetCursorPosX(ImGui.GetCursorPosX() - d.x)
		
		if ImGui.BeginDragDropSource(ImGui.DragDropFlags_SourceNoPreviewTooltip):
			if !_hold_on_prev_frame:
				_init_mouse_pos = main_gui.get_viewport().get_mouse_position()
				_selected_gate = i
			_hold_on_prev_frame = true
			
			ImGui.EndDragDropSource()
		elif i == _selected_gate: 
			_hold_on_prev_frame = false
			_selected_gate = null

		it += 1
	
	if try_switch:
		if _cursor_poses.size() > s_index + 1:
			if _cursor_poses[s_index + 1] < c_pos:
				var t = gates[s_index]
				gates[s_index] = gates[s_index + 1]
				gates[s_index + 1] = t
				_init_mouse_pos.x += _cursor_poses[s_index + 1] - _cursor_poses[s_index]
				gates_reordered.emit(_construct_new_gate_order())
		if s_index > 0:
			if _cursor_poses[s_index - 1] > c_pos:
				var t = gates[s_index]
				gates[s_index] = gates[s_index - 1]
				gates[s_index - 1] = t
				_init_mouse_pos.x -= _cursor_poses[s_index] - _cursor_poses[s_index - 1]
				gates_reordered.emit(_construct_new_gate_order())

	if (ImGui.ButtonEx("+", Vector2(40, 40))):
		ImGui.OpenPopup("gate_chooser")

	var added_gate := ""
	
	if ImGui.BeginPopup("gate_chooser"):
		for g in GateGui.ids:
			if ImGui.Button(g):
				ImGui.CloseCurrentPopup()
				added_gate = g
			ImGui.SameLine()
		ImGui.EndPopup()

	if added_gate != "":
		var newGate
		match added_gate:
			"P":
				newGate = PhaseGateGui.new(added_gate)
			_:
				newGate = GateGui.new(added_gate)
		gates.push_back(newGate)
		gate_added.emit(gates[-1].gate)
		newGate.delete_gate.connect(_on_gate_delete)

	ImGui.EndChild()
	ImGui.EndChild()

func _on_gate_delete(gate: GateGui):
	gate_removed.emit(gate.gate)
	gates.erase(gate)

func sync():
	color_changed.emit(color)

func _construct_new_gate_order() -> Array[Gate]:
	var res: Array[Gate]
	
	for i in gates:
		res.push_back(i.gate)

	return res

func _on_qubit_change():
	qubit_changed.emit(_re_text1[0], _im_text1[0], _re_text2[0], _im_text2[0])
