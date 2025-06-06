@icon("res://resources/tools/respawnNode/icon_reset.png")
extends Marker2D
class_name Respawner

func _ready():
	Signalton.player_reference.connect(collect_player_reference)

func collect_player_reference(ref:Player):
	if not debug:
		ref.global_position = self.global_position
	self.global_position = ref.global_position
	Signalton.player_reference.disconnect(collect_player_reference)


#region	DEBUG

@export var debug :bool
#endregion
