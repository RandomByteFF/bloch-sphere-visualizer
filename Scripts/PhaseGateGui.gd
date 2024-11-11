class_name PhaseGateGui extends GateGui

var input = [""]
var on_change : Callable

@warning_ignore("shadowed_variable")
func _init(identifier: String, on_change : Callable):
	super._init(identifier)
	self.on_change = on_change
	input[0] = "%.04f" % gate.value.d.get_polar()["phi"]

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
	#TODO ExpressionHandler handler = ... 
	gate.value.d = Complex.new_polar(1, input[0].to_float())
	on_change.call()
