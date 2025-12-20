@icon("res://resources/anzhuBeing/player/abilities/jump/icons8-track-and-field-skin-type-1-100.png")

class_name PlayerJump
extends Ability

signal jumped(has_started_the_jump: bool)

@export var jump_time: float = 1.0
@export var jump_distance: float = 2.0
@export var land_recovery_time: float = 0.15
var elevation_map: ElevationsLayer
var landing_location: Vector2
@onready var sfx_land: AudioStreamPlayer = $SfxLand


func __ready() -> void:
	elevation_map = get_tree().get_first_node_in_group('elevations_manager')


func _physics_process(_delta: float) -> void:
	match parent.current_state:
		parent.AbilityStates.IDLING:
			check_for_init_jump()
		parent.AbilityStates.MOVING:
			check_for_init_jump()
		parent.AbilityStates.INIT_JUMP:
			check_if_can_jump()
		parent.AbilityStates.JUMPING:
			pass


func check_for_init_jump() -> void:
	if Inputon.jump_pressed():
		parent.current_state = parent.AbilityStates.INIT_JUMP
		landing_location = elevation_map.evaluate_jump_request(jump_distance, grandparent.current_direction)


func check_if_can_jump() -> void:
	if Inputon.jump_released():
		if landing_location != Vector2.ZERO:
			parent.current_state = parent.AbilityStates.JUMPING
			execute_jump()
		else:
			parent.current_state = parent.AbilityStates.IDLING


func execute_jump() -> void:
	jumped.emit(true)
	Dbgr.tweener_property_disposal([Buildton.tweener(grandparent, 'global_position', landing_location, jump_time)], debug_self)
	await get_tree().create_timer(jump_time - land_recovery_time).timeout
	sfx_land.play()
	await get_tree().create_timer(land_recovery_time).timeout
	jumped.emit(false)
	parent.current_state = parent.AbilityStates.IDLING
