@icon("res://resources/player/abilities/jump/icons8-track-and-field-skin-type-1-100.png")
extends Ability #PlayerJump.gd

@export var jump_time :float = 1.0
@export var jump_distance :float = 1.5
const TILE_SIZE :int = 8
var is_jump_initiated :bool = false
var elevation_map :TileMapLayer

func _ready() -> void:
	Libraryton.elevation_reference.connect(func(ref):elevation_map = ref)

func jump()->void:
	if Inputon.jump_pressed() and parent.can_jump:
		is_jump_initiated = true # Use this to evaluate jump in the future. Movement and actions must be halted tho.
	if Inputon.jump_released() and is_jump_initiated:
		var landing_location :Vector2i = elevation_map.evaluate_jump_request(jump_distance)
		if landing_location != Vector2i.ZERO:
			parent.is_jumping.emit()
			Builderton.tweener(grandparent, 'global_position', landing_location, jump_time)
			await get_tree().create_timer(jump_time).timeout
			parent.finished_jumping.emit()
