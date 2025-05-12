@icon("res://resources/tools/respawnNode/icon_reset.png")
extends Marker2D #RespawnNode.gd

var player:Player:
	set(value): if player != value:
		player = value
		self.global_position = player.global_position

func _ready():
	Libraryton.player_reference.connect(collect_player_reference)

func collect_player_reference(ref:Player):
	player = ref
	Libraryton.player_reference.disconnect(collect_player_reference)


#region	DEBUG

@export var debug :bool
#endregion
