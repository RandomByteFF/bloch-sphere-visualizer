class_name ArrowController

var arrow: Arrow

## Default arrow color. The length has to be 4, else ImGui will crash the application
## without any error whatsoever. 
var color = [0.0, 0.0, 0.0, 1.0]
var bit_index := 0
var color_picker_open = false
var identifier := "a"
var _re_text1 = ["1"]
var _im_text1 = ["0"]
var _re_text2 = ["0"]
var _im_text2 = ["0"]
var gates = []

var default_gates = [ Gate.H, Gate.X, Gate.Y, Gate.Z, Gate.P() ]

@warning_ignore("shadowed_variable")
func ready(arrow):
	self.arrow = arrow
	arrow.set_color(color)


func gui():
	ImGui.BeginChild("arrow_controller_" + str(bit_index), Vector2(0, 0), ImGui.ChildFlags_AlwaysAutoResize | ImGui.ChildFlags_AutoResizeX | ImGui.ChildFlags_AutoResizeY)
	
	# Identifier text
	ImGui.AlignTextToFramePadding()
	ImGui.Text("|" + identifier + ">")
	ImGui.SameLine()

	if ImGui.ColorButton("##arrow_color_button", Color(color[0], color[1], color[2], color[3])):
		color_picker_open = !color_picker_open
	ImGui.SameLine()

	# Complex number 1
	ImGui.PushItemWidth(80)
	ImGui.InputText("##re_text_1", _re_text1, 40)
	ImGui.SameLine()
	ImGui.InputText("##im_text_1", _im_text1, 40)
	ImGui.SameLine()
	ImGui.PopItemWidth()
	ImGui.Text("i")

	#Complex number 2
	ImGui.PushItemWidth(80)
	# ImGui is a piece of shit, but oddly, it's really useful sometimes
	# (I still love it tho)
	ImGui.SetCursorPosX(56)
	ImGui.InputText("##re_text_2", _re_text2, 40)
	ImGui.SameLine()
	ImGui.InputText("##im_text_2", _im_text2, 40)
	ImGui.SameLine()
	ImGui.PopItemWidth()
	ImGui.Text("i")

	# Color picker (if color picker is open)
	if color_picker_open:
		if ImGui.ColorPicker4("##Arrow color", color, ImGui.ColorEditFlags_NoSidePreview | ImGui.ColorEditFlags_NoSmallPreview):
			arrow.set_color(color)
	
	ImGui.BeginChild("gates", Vector2(0, 70), ImGui.ChildFlags_Border, ImGui.WindowFlags_HorizontalScrollbar)
	for i in gates:
		i.gui()
		ImGui.SameLine()
	
	if (ImGui.ButtonEx("+", Vector2(40, 40))):
		ImGui.OpenPopup("gate_chooser")

	var added_gate := ""
	

	if ImGui.BeginPopup("gate_chooser"):
		
		for g in default_gates:
			if ImGui.Button(g.abbreviation):
				ImGui.CloseCurrentPopup()
				added_gate = g.abbreviation
			ImGui.SameLine()
		ImGui.EndPopup()

	if added_gate != "":
		var found = default_gates.filter(func(g): return g.abbreviation == added_gate)

		if not found.is_empty():
			gates.push_back(found[0])
		else:
			push_warning("No gate with label recognized: " + added_gate)

	ImGui.EndChild()
	ImGui.EndChild()
