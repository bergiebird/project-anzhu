@icon("res://resources/anzhuBeing/player/abilities/jump/icons8-track-and-field-skin-type-1-100.png")
extends Ability
class_name PlayerJump

@export var jump_time :float = 1.0
@export var jump_distance :float = 2.0

var elevation_map :ElevationsLayer
var landing_location :Vector2
var only_one_may_enter :bool = true
@onready var sfx_land :AudioStreamPlayer = $SfxLand

func _ready() -> void:
	Libraryton.elevation_reference.connect(func(ref :TileMapLayer)->void:elevation_map = ref)

func _physics_process(_delta :float)->void:
	match parent.current_state:
		parent.AbilityStates.IDLING:    check_for_init_jump()
		parent.AbilityStates.MOVING:    check_for_init_jump()
		parent.AbilityStates.INIT_JUMP: check_if_can_jump()
		parent.AbilityStates.JUMPING:   execute_jump()

func check_for_init_jump():
	if Inputon.jump_pressed():
		parent.current_state = parent.AbilityStates.INIT_JUMP
		landing_location = elevation_map.evaluate_jump_request(jump_distance, grandparent.current_direction)

func check_if_can_jump():
	if Inputon.jump_released():
		if landing_location != Vector2.ZERO:
			parent.current_state = parent.AbilityStates.JUMPING
		else:
			parent.current_state = parent.AbilityStates.IDLING

func execute_jump():
	if only_one_may_enter:
				only_one_may_enter = false
				Debuggerton.tweener_property_disposal([Builderton.tweener(grandparent, 'global_position', landing_location, jump_time)], debug)
				await get_tree().create_timer(jump_time - 0.13).timeout
				sfx_land.play()
				await get_tree().create_timer(0.13).timeout
				only_one_may_enter = true
				parent.current_state = parent.AbilityStates.IDLING
###
##	DEBUG
###
@export var debug :bool
