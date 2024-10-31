class_name Gui extends Node

@export var bit_index := 0
@onready var _title := "QBit editor"

var qubit_gui = []

func _ready() -> void:
	add_qbit()
	add_qbit()

func _process(_delta):
	ImGui.SetNextWindowPos(Vector2(-1, -1))
	ImGui.Begin(_title, Array(), ImGui.WindowFlags_NoSavedSettings | ImGui.WindowFlags_AlwaysAutoResize )
	
	for i in qubit_gui:
		i.gui()
	
	ImGui.End()

func add_qbit():
	var gui = QubitGui.new()
	gui.bit_index = bit_index
	qubit_gui.push_back(gui)
	%ControlStore.add_qubit(gui)
	bit_index += 1
	gui.sync()
