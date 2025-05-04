@icon("res://resources/tools/respawnNode/icon_reset.png")
extends Marker2D #RespawnNode.gd


var player :Player:
	set(value): if player != value:
		player = value
		self.global_position = player.global_position


func _ready() -> void:
	Debuggerton.signal_checker([
		Libraryton.player_reference.connect
		(func(ref:Player)->void: 
				player = ref),
	], debug)


###
##	DEBUG
###
@export var debug :bool
