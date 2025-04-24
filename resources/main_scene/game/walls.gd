extends CanvasGroup #Walls.gd

@onready var invisible_walls :TileMapLayer = $InvisibleWalls

func _ready()->void:
	invisible_walls.visible = false
