extends CanvasGroup #Walls.gd

@onready var invisible_walls :TileMapLayer = $InvisibleWalls

func _ready()->void:
	_debug()


###
## 	DEBUG
###
@export_group('DEBUG')
@export var debug :bool = false

func _debug()->void:
	invisible_walls.visible = debug
