class_name PlayerAnimations extends AnimatedSprite2D #PlayerAnimations.gd

const FLASH_AMOUNT :int = 4
@export var animations_reloads_reload_time :float = 0.5
@export var modified_speed_up :float = 0.16
var is_dead :bool = false
var is_colored :bool = false
var anim_direction :String = '_SIDE'
var old_flip_h :bool = false
@onready var parent :AnzhuBeing = get_parent()
@onready var breath :GPUParticles2D = $Breath
@onready var abilities :Abilities = parent.get_node('Abilities')
@onready var reload_anim :ReloadAnimation = $ReloadAnimation
@export var is_printing :bool = false ##HACK by Vrood

func _ready()->void:
	Debuggerton.signal_checker([
		parent.was_struck.connect(flash_red),
		parent.has_died.connect(func()->void: is_dead = true),
		parent.direction_should_flip.connect(func(should_flip:bool)->void:
			flip_h = should_flip),
		abilities.modified_reload.connect(anim_reload_modified),
		abilities.reloading.connect(anim_reloading_recieved),
		abilities.initializing_jump.connect(begin_jump_animation),
		abilities.jumping.connect(execute_jump_animations),
	])

func anim_reloading_recieved(is_reloading:bool)->void:
	if is_reloading:
		abilities.can_move = false
		reload_anim.start_routine()

func anim_reload_modified(is_reload_modified :bool)->void:
	if is_reload_modified:
		speed_scale += modified_speed_up

func execute_jump_animations(is_jumping :bool)->void:
	if is_jumping:
		just_play('executeJump', true, 1)

func begin_jump_animation(is_jump_initialized :bool)->void:
	if is_jump_initialized:
		just_play('readyJump', true, 1)

func reload_animation_finished()->void:
	if abilities.has_full_ammo == false:
		if_debug('reload finished ' + animation)
		abilities.has_full_ammo = true

func being_physics_process(_delta :float)->void:
	var speed :int = int(parent.velocity.length())
	if abilities.is_reloading or abilities.is_jumping or abilities.is_initializing_jump:
		if is_printing: print('stopped') ## HACK by Vrood
		return
	if speed > 30:
		just_play('run')
	elif 30 >= speed and speed > 0:
		just_play('walk')
	else:
		if is_printing: print('idled')
		just_play('idle')

func flipper(should_flip :bool=flip_h)->void:
	if flip_h != should_flip:
		flip_h = should_flip

func just_play(anim_name :String, should_stop :bool=false, force_speed_scale:int = -1)->void:
	anim_direction = Directon.ANIM_NAME[parent.current_direction]
	if should_stop:
		stop()
	efficiency_check(force_speed_scale)
	play(anim_name + anim_direction)
	if_debug("anim: " + anim_name + "  anim_direction:  " + anim_direction)

func efficiency_check(force_speed_scale :int = -1)->void:
	if force_speed_scale != -1:  speed_scale = force_speed_scale
	elif abilities.is_efficient: speed_scale = 1
	else:                        speed_scale = 0.60

func flash_red()->void:
	modulate = Swatchton.RED_TOMATO
	for flashes :int in FLASH_AMOUNT:
		is_colored = !is_colored
		self_modulate = Swatchton.RED_TOMATO if is_colored else Swatchton.BASIC_WHITE
		if not is_dead:
			await get_tree().create_timer(.4).timeout
	modulate = Swatchton.BASIC_WHITE
	self_modulate = Swatchton.BASIC_WHITE

###
## DEBUG
###
@export_group('Debug')
@export var debug_animations :bool = false
@export var debugger_color :Color = Color("e67a84")

func debug()->void:
	Debuggerton.enable_print(self.name, debugger_color)
	debug_animations = true

func if_debug(message :String)->void:
	if debug_animations:
		Debuggerton.dprint(message, debugger_color)
