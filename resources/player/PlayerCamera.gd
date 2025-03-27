extends Camera2D #PlayerCamera.gd

var looing_dict:Dictionary[String,Vector2] = {
	"NORTH":
		Vector2(8,8),
	"SOUTH":
		Vector2(8,8),
	"WEST":
		Vector2(8,8),
	"EAST":
		Vector2(8,8),
}



func _process(delta: float) -> void:
	pass
