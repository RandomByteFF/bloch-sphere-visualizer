extends Node

func _process(_delta):
	ImGui.Begin("My Window")
	ImGui.Text("hello from GDScript")
	ImGui.End()
