class_name Gui extends Node

@export var _axis: Array[Node3D]
@export var _labels: Array[Label]
@export var _sphere: CSGSphere3D

var bit_index := 0
@onready var _title := "QBit editor"
var _shader1 = preload("res://Shaders/BlochSphere.tres")
var _shader2 = preload("res://Shaders/BlochSphereEmpty.tres")

var qubit_gui = []

var _show_axis := [true]
var _show_ket_labels := [true]
var _show_grid_lines := [true]

func _process(_delta):
	ImGui.SetNextWindowPos(Vector2(-1, -1))
	ImGui.SetNextWindowSize(Vector2(255, 500), ImGui.Cond_Once)
	ImGui.Begin(_title, Array(), ImGui.WindowFlags_NoSavedSettings)
	
	for i in qubit_gui:
		i.gui()
	
	# Totally arbitary numbers, came to me in a vision
	# I'm merely a vessel for a higher power
	if ImGui.ButtonEx("+", Vector2(ImGui.GetWindowSize().x - 16, 50)):
		add_qbit()
	
	if ImGui.TreeNode("Settings"):
		if ImGui.Checkbox(" Show axis", _show_axis):
			_axis.any(func(it): it.visible = _show_axis[0])
		if ImGui.Checkbox(" Show ket labels", _show_ket_labels):
			_labels.any(func(it): it.visible = _show_ket_labels[0])
		if ImGui.Checkbox(" Show grid lines", _show_grid_lines):
			_sphere.material = _shader1 if _show_grid_lines[0] else _shader2
		ImGui.TreePop()

	ImGui.End()

func add_qbit():
	var gui = QubitGui.new(self)
	gui.bit_index = bit_index
	qubit_gui.push_back(gui)
	%ControlStore.add_qubit(gui)
	bit_index += 1
	gui.sync()

func remove_qubit(q: QubitGui):
	qubit_gui.erase(q)
