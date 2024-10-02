extends CanvasItem

@export var follow: Node3D 

func _process(_delta: float) -> void:
	self.position = %Camera.unproject_position(follow.position)
	self.position -= self.size / 2
