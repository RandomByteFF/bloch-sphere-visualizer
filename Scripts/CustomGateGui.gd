class_name CustomGateGui extends GateGui

var a = [""]
var b = [""]
var c = [""]
var d = [""]
const element_width = 100

var on_change : Callable

@warning_ignore("shadowed_variable")
func _init(identifier: String, on_change : Callable):
	super._init(identifier)
	self.on_change = on_change
	a[0] = "%s" % gate.value.a._to_string()
	b[0] = "%s" % gate.value.b._to_string()
	c[0] = "%s" % gate.value.c._to_string()
	d[0] = "%s" % gate.value.d._to_string()

func _custom_popup():
	ImGui.BeginTable("unitary_table", 2)

	ImGui.TableSetupColumnEx("##column1", ImGui.TableColumnFlags_WidthFixed, element_width)
	ImGui.TableSetupColumnEx("##column2", ImGui.TableColumnFlags_WidthFixed, element_width)

	ImGui.TableNextRow()
	ImGui.TableNextColumn()
	ImGui.PushItemWidth(element_width)
	if ImGui.InputText("##phase_input_1", a, 32):
		update_gate(0)

	ImGui.TableNextColumn()
	ImGui.PushItemWidth(element_width)
	if ImGui.InputText("##phase_input_2", b, 32):
		update_gate(1)

	ImGui.TableNextRow()
	ImGui.TableNextColumn()
	if ImGui.InputText("##phase_input_3", c, 32):
		update_gate(2)

	ImGui.TableNextColumn()
	if ImGui.InputText("##phase_input_4", d, 32):
		update_gate(3)

	ImGui.EndTable()

func update_gate(target : int):
	#TODO ExpressionHandler handler = ...
	var value = Complex.new(-1, 0)

	if target == 0:
		gate.value.a = value
	elif target == 1:
		gate.value.b = value
	elif target == 2:
		gate.value.c = value
	elif target == 3:
		gate.value.d = value

	if gate.value._is_unitary():
		on_change.call()