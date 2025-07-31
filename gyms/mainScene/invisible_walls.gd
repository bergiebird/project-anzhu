## Simple auto toggle

class_name InvisibleWalls
extends TileMapLayer


func _ready() -> void:
	visible = false
	Sgnl.toggle_debug_invisible.connect(_toggle_invisible_walls)

func _toggle_invisible_walls():
	visible = !visible
