@icon("res://resources/anzhuBeing/player/abilities/jump/icons8-track-and-field-skin-type-1-100.png")
extends Ability #PlayerJump.gd
@export var jump_time :float = 1.0
@export var jump_distance :float = 2.0

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
				landing_location = elevation_map.evaluate_jump_request(jump_distance, grandparent.current_direction)
			JumpSequence.ACCEPTED:
				Debuggerton.tweener_property_disposal([
					Builderton.tweener(grandparent, 'global_position', landing_location, jump_time)
				], debug)
				parent.is_jumping = true

var elevation_map :ElevationsLayer
var landing_location :Vector2
var only_one_may_enter :bool = true
@onready var sfx_land :AudioStreamPlayer = $SfxLand

func _ready() -> void:
	Debuggerton.signal_checker([
		Libraryton.elevation_reference.connect(func(ref :TileMapLayer)->void:elevation_map = ref)
	])

func process_ability(_delta :float)->void:
	match current_jump_sequence:
		JumpSequence.NONE:
			if Inputon.jump_pressed():
				current_jump_sequence = JumpSequence.PRESSED
		JumpSequence.PRESSED:
			if Inputon.jump_released():
				if landing_location != Vector2.ZERO:
					current_jump_sequence = JumpSequence.ACCEPTED
				else:
					current_jump_sequence = JumpSequence.NONE
		JumpSequence.ACCEPTED:
			if only_one_may_enter:
				only_one_may_enter = false
				await get_tree().create_timer(jump_time - 0.13).timeout
				sfx_land.play()
				await get_tree().create_timer(0.13).timeout
				current_jump_sequence = JumpSequence.NONE
				only_one_may_enter = true

###
##	DEBUG
###
@export var debug :bool
