extends Node

@export var arrow: Arrow

## Default arrow color. The length has to be 4, else ImGui will crash the application
## without any error whatsoever. 
@export var color = [0.0, 0.0, 0.0, 0.0]
@export var bit_index = 0
var color_picker_open = false

@onready var _title = "Q[%s]" % bit_index

func _ready() -> void:
	arrow.set_color(color)

func _process(_delta):
	ImGui.Begin(_title, Array())
	ImGui.AlignTextToFramePadding()
	ImGui.Text("Indicator color: ")
	ImGui.SameLine()

	if ImGui.ColorButton("##arrow_color_button", Color(color[0], color[1], color[2], color[3])):
		color_picker_open = !color_picker_open
	if color_picker_open:
		if ImGui.ColorPicker4("##Arrow color", color, ImGui.ColorEditFlags_NoSidePreview | ImGui.ColorEditFlags_NoSmallPreview):
			arrow.set_color(color)
	
	ImGui.End()
