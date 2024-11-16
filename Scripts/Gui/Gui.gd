class_name Gui extends Node

var bit_index := 0
@onready var _title := "QBit editor"

var qubit_gui = []

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
