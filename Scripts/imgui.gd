extends Node

@export var qbit_index := 0
@export var bloch_sphere: Node
@export var arrow_scene: PackedScene
@onready var _title := "QBit editor"
@onready var arrow_controllers: Array

func _ready() -> void:
	add_qbit()
	add_qbit()

func _process(_delta):
	ImGui.SetNextWindowPos(Vector2(-1, -1))
	ImGui.Begin(_title, Array(), ImGui.WindowFlags_NoSavedSettings | ImGui.WindowFlags_AlwaysAutoResize )
	
	for i in arrow_controllers:
		i.gui()
	
	ImGui.End()

func add_qbit():
	arrow_controllers.push_back(ArrowController.new())
	var arrow = arrow_scene.instantiate()
	bloch_sphere.add_child(arrow)
	
	arrow_controllers[-1].ready(arrow)
	arrow_controllers[-1].bit_index = qbit_index
	qbit_index += 1
