extends CanvasGroup #Walls.gd

@onready var invisible :TileMapLayer = $InvisibleWalls
@onready var elevation :TileMapLayer = $ElevationsLayer



func _ready()->void:
	Signalton.toggle_debug_elevation.connect(func(): elevation.visible = !elevation.visible)
	Signalton.toggle_debug_invisible.connect(func(): invisible.visible = !invisible.visible)
