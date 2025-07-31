@icon("res://resources/tools/respawnNode/icon_reset.png")

extends Marker2D
class_name Respawner


@export var debug: bool


func _ready():
	var player: Player = get_tree().get_first_node_in_group("player")
	if not debug:
		player.global_position = self.global_position
	self.global_position = player.global_position
