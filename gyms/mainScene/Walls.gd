extends CanvasGroup
class_name Walls
@onready var invisible:TileMapLayer = $InvisibleWalls


func _ready() -> void:
	invisible.visible = false
	Signalton.toggle_debug_invisible.connect(func(): invisible.visible = !invisible.visible)
