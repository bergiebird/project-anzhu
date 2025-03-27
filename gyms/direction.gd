extends Node #Direction.gd

@export var is_player :bool = false
enum Direction{NORTH,SOUTH,EAST,WEST}
var currentDirection :int = Direction.SOUTH

func _process(delta: float) -> void:
	pass
