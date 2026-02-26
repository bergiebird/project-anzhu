extends AnimatedSprite2D
class_name PlayerAnimations

@export var FLASH_AMOUNT: int = 4
@export var animations_reloads_reload_time: float = 0.5
@export var modified_speed_up: float = 0.16

var is_dead: bool = false
var is_colored: bool = false
var anim_direction: String = '_SIDE'

@onready var parent: AnzhuBeing = get_parent()
@onready var abilities: Abilities = parent.get_node('Abilities')


func _process(_delta: float) -> void:
	var speed: int = int(parent.velocity.length())
	match abilities.current_state:
		abilities.AbilityStates.MOVING:
			if speed > 400:
				just_play('run')
			else:
				just_play('walk')
		abilities.AbilityStates.IDLING:
				just_play('idle')


func has_died() -> void:
	is_dead = true


func update_direction(bol: Dictionary) -> void:
	if flip_h != bol["Flip"]:
		flip_h = bol["Flip"]


func just_play(anim_name: String, should_stop: bool = false, force_speed_scale: int = -1) -> void:
	anim_direction = Directon.ANIM_NAME[parent.current_direction]
	if should_stop:
		stop()
	efficiency_check(force_speed_scale)
	play(anim_name + anim_direction)


func efficiency_check(force_speed_scale: int = -1) -> void:
	if force_speed_scale == -1:
		if abilities.is_efficient:
			speed_scale = 1
		else:
			speed_scale = 0.60
	else:
		speed_scale = force_speed_scale


func was_struck() -> void:
	modulate = Lib.Palette.RED_TOMATO
	for flashes: int in FLASH_AMOUNT:
		is_colored = !is_colored
		self_modulate = Lib.Palette.RED_TOMATO if is_colored else Lib.BasicPalette.BASIC_WHITE
		if not is_dead:
			await get_tree().create_timer(.4).timeout
	modulate = Lib.BasicPalette.BASIC_WHITE
	self_modulate = Lib.BasicPalette.BASIC_WHITE


func _on_jump_prepared_jump() -> void:
	just_play('readyJump', true, 1)


func _on_jump_started_jump() -> void:
	just_play('executeJump', true, 1)
