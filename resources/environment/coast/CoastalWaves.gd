extends AudioStreamPlayer2D #CostalWaves.gd

@onready var player :Player = %Player


func _process(delta:float)->void:
	global_position.y = player.global_position.y
