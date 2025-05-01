@icon("res://resources/anzhuBeing/player/abilities/jump/icons8-track-and-field-skin-type-1-100.png")
extends Ability #PlayerJump.gd
@export var jump_time :float = 1.0
@export var jump_distance :float = 1.5

enum JumpSequence {NONE, PRESSED, ACCEPTED}

var current_jump_sequence :int = JumpSequence.NONE:
	set(value): if current_jump_sequence != value:
		current_jump_sequence = value
		match current_jump_sequence:
			JumpSequence.NONE:
				parent.is_initializing_jump = false
				parent.is_jumping = false
			JumpSequence.PRESSED:
				parent.is_initializing_jump = true
				landing_location = elevation_map.evaluate_jump_request(jump_distance)
			JumpSequence.ACCEPTED:
				Builderton.tweener(grandparent, 'global_position', landing_location, jump_time)
				parent.is_jumping = true

var elevation_map :TileMapLayer
var parent :Abilities
var grandparent :Player
var landing_location :Vector2
var only_one_may_enter :bool = true
@onready var sfx_land :AudioStreamPlayer2D = $SfxLand

func _ready() -> void:
	Libraryton.elevation_reference.connect(func(ref):elevation_map = ref)

func process_ability()->void:
	match current_jump_sequence:
		JumpSequence.NONE:
			if Inputon.jump_pressed():              current_jump_sequence = JumpSequence.PRESSED
		JumpSequence.PRESSED:
			if Inputon.jump_released():
				if landing_location != Vector2.ZERO:  current_jump_sequence = JumpSequence.ACCEPTED
				else:                                 current_jump_sequence = JumpSequence.NONE
		JumpSequence.ACCEPTED:
			if only_one_may_enter:
				only_one_may_enter = false
				await get_tree().create_timer(jump_time).timeout
				sfx_land.play()
				current_jump_sequence = JumpSequence.NONE
				only_one_may_enter = true
