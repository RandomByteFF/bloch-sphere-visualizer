class_name PhaseGateGui extends GateGui

var input = [""]
func _custom_popup():
	ImGui.BeginTable("phase_table", 2)

	ImGui.TableSetupColumnEx("##column1", ImGui.TableColumnFlags_WidthFixed, 20)
	ImGui.TableSetupColumnEx("##column2", ImGui.TableColumnFlags_WidthFixed, 90)
	ImGui.TableNextRow()
	ImGui.TableNextColumn()
	ImGui.Text("1")

	ImGui.TableNextColumn()
	ImGui.SetCursorPosX(ImGui.GetCursorPosX() + ImGui.GetColumnWidth() / 2)
	ImGui.Text("0")

	ImGui.TableNextRow()
	ImGui.TableSetColumnIndex(0)
	ImGui.Text("0")

	ImGui.TableNextColumn()
	ImGui.Text("e^i*")
	ImGui.SameLine()
	if ImGui.InputText("##phase_input", input, 8):
		update_gate()

	ImGui.EndTable()

func update_gate():
	# Hajrá Kristóf
	pass
