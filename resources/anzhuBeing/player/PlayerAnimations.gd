extends AnimatedSprite2D #PlayerAnimations.gd

const FLASH_AMOUNT :int = 4
@export var animations_reloads_reload_time :float = 0.5
@export var modified_speed_up :float = 0.16
var is_dead :bool = false
var is_colored :bool = false
var anim_direction :String = 'SIDE'
var is_efficient :bool = false
@onready var parent :AnzhuBeing = get_parent()
@onready var breath :GPUParticles2D = $Breath
@onready var abilities :Abilities = parent.get_node('Abilities')

func _ready()->void:
	parent.was_struck.connect(flash_red)
	parent.has_died.connect(func(): is_dead = true)
	abilities.modified_reload.connect(anim_reload_modified)
	abilities.reloading.connect(anim_reloading_recieved)
	abilities.efficiency.connect(func(bol): is_efficient = bol)
	abilities.initializing_jump.connect(begin_jump_animation)
	abilities.jumping.connect(execute_jump_animations)
	animation_finished.connect(reload_animation_finished)

func anim_reloading_recieved(is_reloading:bool)->void:
	if is_reloading:
		abilities.can_move = false
		just_play('reload', true, 1)

func anim_reload_modified(is_reload_modified :bool)->void:
	if is_reload_modified:
		speed_scale+= modified_speed_up

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

func movement_animation(incoming_velocity :Vector2)->void:
	var speed = incoming_velocity.length()
	if abilities.is_reloading or abilities.is_jumping or abilities.is_initializing_jump:
		return
	if speed > 30:
		just_play('run')
	elif 30 >= speed and speed > 0:
		just_play('walk')
	else:
		just_play('idle')

var old_flip_h :bool = false
func just_play(anim_name :String='idle', should_stop :bool=false, force_speed_scale:int = -1)->void:
	anim_direction = Directon.get_anim_direction()
	if should_stop:
		stop()
	flip_h = Directon.get_should_flip()
	if flip_h != old_flip_h:
		breath.change_breath_direction(flip_h)
		old_flip_h = flip_h
	efficiency_check(force_speed_scale)
	play(anim_name + anim_direction)
	if_debug("anim: " + anim_name)

func efficiency_check(force_speed_scale :int = -1)->void:
	if force_speed_scale != -1:
		speed_scale = force_speed_scale
	elif is_efficient:
		speed_scale = 1
	else:
		speed_scale = 0.60

func flash_red()->void:
	modulate = Swatchton.RED_TOMATO
	for flashes in FLASH_AMOUNT:
		is_colored = !is_colored
		self_modulate = Swatchton.RED_TOMATO if is_colored else Swatchton.BASIC_WHITE
		if not is_dead: await get_tree().create_timer(.4).timeout
	modulate = Swatchton.BASIC_WHITE
	self_modulate = Swatchton.BASIC_WHITE

###
## DEBUG
###
@export_group('Debug')
@export var debug_animations :bool = false
@export var debugger_color :Color = Color("e67a84")
@onready var dcolor = debugger_color.to_html()

func debug()->void:
	debug_animations = Debuggerton.enable_print(self.name, dcolor)

func if_debug(message :String)->void:
	if debug_animations:
		Debuggerton.dprint(message, dcolor)
