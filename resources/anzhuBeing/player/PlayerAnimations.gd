class_name PlayerAnimations extends AnimatedSprite2D #PlayerAnimations.gd

const FLASH_AMOUNT :int = 4
@export var animations_reloads_reload_time :float = 0.5
@export var modified_speed_up :float = 0.16
var is_dead :bool = false
var is_colored :bool = false
var anim_direction :String = '_SIDE'
var old_flip_h :bool = false
@onready var parent :AnzhuBeing = get_parent()
@onready var mask :Mask = parent.get_node("Mask")
@onready var abilities :Abilities = parent.get_node('Abilities')
@onready var breath :GPUParticles2D = $Breath
@onready var reload_anim :ReloadAnimation = $ReloadAnimation

func _ready()->void:
	parent.observer_null.connect(func(func_name): Observerton.match_null(self, func_name))
	parent.observer_one.connect(func(func_name, one :Variant): Observerton.match_one(self, func_name, one))
	parent.observer_two.connect(func(func_name, one :Variant, two :Variant): Observerton.match_two(self, func_name, one, two))

func has_died()->void:
	is_dead = true

func should_flip(yes :bool):
	flip_h = yes

func reloading(is_reloading:bool)->void:
	if is_reloading:
		abilities.can_move = false
		reload_anim.start_routine()

func modified_reload(is_reload_modified :bool)->void:
	if is_reload_modified:
		speed_scale += modified_speed_up

func jumping(is_jumping :bool)->void:
	if is_jumping:
		just_play('executeJump', true, 1)

func initializing_jump(is_jump_initialized :bool)->void:
	if is_jump_initialized:
		just_play('readyJump', true, 1)

func reload_animation_finished()->void:
	if abilities.has_full_ammo == false:
		if_debug('reload finished ' + animation)
		abilities.has_full_ammo = true

func being_physics_process(_delta :float)->void:
	var speed :int = int(parent.velocity.length())
	if abilities.is_reloading or abilities.is_jumping or abilities.is_initializing_jump:
		if_debug('stopped')
		return
	if speed > 30:
		just_play('run')
	elif 30 >= speed and speed > 0:
		just_play('walk')
	else:
		if_debug('idled')
		just_play('idle')

func direction_flipped(flipper :bool=flip_h)->void:
	if flip_h != flipper:
		flip_h = flipper

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

func was_struck()->void:
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

func debug()->void:
	Debuggerton.enable_print(self.name, debugger_color)
	debug_animations = true

func if_debug(message :String)->void:
	if debug_animations:
		Debuggerton.dprint(message, debugger_color)

#endregion
