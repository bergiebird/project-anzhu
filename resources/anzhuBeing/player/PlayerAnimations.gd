extends AnimatedSprite2D
class_name PlayerAnimations

const FLASH_AMOUNT :int = 4
@export var animations_reloads_reload_time :float = 0.5
@export var modified_speed_up :float = 0.16
var is_dead :bool = false
var is_colored :bool = false
var anim_direction :String = '_SIDE'
@onready var parent :AnzhuBeing = get_parent()
@onready var mask :Mask = parent.get_node("Mask")
@onready var abilities :Abilities = parent.get_node('Abilities')
@onready var breath :GPUParticles2D = $Breath
@onready var reload_anim :ReloadAnimation = $ReloadAnimation

func has_died():
	is_dead = true

func should_flip(yes :bool):
	flip_h = yes

func reloading(is_reloading :bool):
	if is_reloading:
		reload_anim.start_routine()

func modified_reload(is_reload_modified :bool):
	if is_reload_modified:
		speed_scale += modified_speed_up

func jumping(is_jumping :bool):
	if is_jumping:
		just_play('executeJump', true, 1)

func initializing_jump(is_jump_initialized :bool):
	if is_jump_initialized:
		just_play('readyJump', true, 1)

func reload_animation_finished():
	if_debug('reload finished ' + animation)
	abilities.current_state = abilities.AbilityStates.IDLING

func _process(_delta :float):
	var speed :int = int(parent.velocity.length())
	match abilities.current_state:
		abilities.AbilityStates.RELOADING:
			return
		abilities.AbilityStates.JUMPING:
			return
		abilities.AbilityStates.RELOADING:
			return
		abilities.AbilityStates.MOVING:
			if speed > 200:
				just_play('run')
			else:
				just_play('walk')
		abilities.AbilityStates.IDLING:
				just_play('idle')


func update_direction(flipper :bool=flip_h):
	if flip_h != flipper:
		flip_h = flipper

func just_play(anim_name :String, should_stop :bool=false, force_speed_scale:int = -1):
	anim_direction = Directon.ANIM_NAME[parent.current_direction]
	if should_stop:
		stop()
	efficiency_check(force_speed_scale)
	play(anim_name + anim_direction)
	if_debug("anim: " + anim_name + "  anim_direction:  " + anim_direction)

func efficiency_check(force_speed_scale :int = -1):
	if force_speed_scale == -1:
		if abilities.is_efficient:
			speed_scale = 1
		else:
			speed_scale = 0.60
	else:
		speed_scale = force_speed_scale

func was_struck():
	modulate = Swatchton.RED_TOMATO
	for flashes :int in FLASH_AMOUNT:
		is_colored = !is_colored
		self_modulate = Swatchton.RED_TOMATO if is_colored else Swatchton.BASIC_WHITE
		if not is_dead:
			await get_tree().create_timer(.4).timeout
	modulate = Swatchton.BASIC_WHITE
	self_modulate = Swatchton.BASIC_WHITE

#region DEBUG
@export_group('Debug')
@export var debug_animations :bool = false
@export var debugger_color :Color = Color("e67a84")

func debug():
	Debuggerton.enable_print(self.name, debugger_color)
	debug_animations = true

func if_debug(message :String):
	if debug_animations:
		Debuggerton.dprint(message, debugger_color)

#endregion
