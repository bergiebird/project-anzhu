extends CanvasGroup
class_name Walls

@onready var invisible:TileMapLayer = $InvisibleWalls
@onready var elevation:TileMapLayer = $ElevationsLayer


func _ready() -> void:
	elevation.visible = false
	invisible.visible = false
	Signalton.toggle_debug_elevation.connect(func(): elevation.visible = !elevation.visible)
	Signalton.toggle_debug_invisible.connect(func(): invisible.visible = !invisible.visible)
	for child in get_children():
		child.global_position = Vector2.ZERO
