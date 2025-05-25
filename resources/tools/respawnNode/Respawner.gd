@icon("res://resources/tools/respawnNode/icon_reset.png")
extends Marker2D
class_name Respawner

func _ready():
	Libraryton.player_reference.connect(collect_player_reference)

func collect_player_reference(ref:Player):
	self.global_position = ref.global_position
	Libraryton.player_reference.disconnect(collect_player_reference)


#region	DEBUG

@export var debug :bool
#endregion
