@icon("res://resources/tools/respawnNode/icon_reset.png")

extends Marker2D
class_name Respawner

enum RespawnType {AT_DEBUG_LOCATION, AT_PRESET_LOCATION}

@export var respawn_type: RespawnType = RespawnType.AT_PRESET_LOCATION



func _ready() -> void:
	var player: Player = get_tree().get_first_node_in_group("player")

	match respawn_type:
		RespawnType.AT_DEBUG_LOCATION:
			pass
		RespawnType.AT_PRESET_LOCATION:
			player.global_position = global_position

	global_position = player.global_position
