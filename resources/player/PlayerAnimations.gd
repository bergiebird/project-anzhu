extends AnimatedSprite2D #PlayerAnimations.gd
signal reloaded
@export var animations_reloads_reload_time :float = 0.5
var is_dead = false
var is_colored :bool = false
var audio :Node2D
var current_direction :String = '_SIDE'
var node_dictionary :Dictionary[String, Node] = {}:
	set(value):
		node_dictionary = value
		audio = node_dictionary['AudioManager']
		abilities = node_dictionary['Abilities']
@export var modified_speed_up :float = 0.16
@onready var abilities :Node = %Abilities
@onready var parent :AnzhuBeing = get_parent()

func _ready()->void:
	parent.was_struck.connect(flash_red)
	parent.has_died.connect(func():is_dead = true)
	abilities.modified_reload.connect(func():speed_scale+= modified_speed_up)
	abilities.start_reload.connect(start_reload_animation)
	animation_finished.connect(reload_animation_finished)

func reload_animation_finished()->void:
	if animation == 'reload_' + current_direction:
		reloaded.emit()
		just_play('idle')
		speed_scale = 1

func start_reload_animation()->void:
	stop()
	just_play('reload')
	speed_scale = 1
	await get_tree().create_timer(animations_reloads_reload_time).timeout

func should_flip(anim_name :String)->void:
	if abilities.is_efficient:
		speed_scale = 1
	else:
		speed_scale = 0.60
	current_direction = Directon.anim_wants_to_know_where_we_looking()
	if current_direction == "WEST":
		flip_h = true
	else:
		flip_h = false
	if current_direction == "WEST" or current_direction == "EAST":
		current_direction = "SIDE"

func just_play(anim_name :String)->void:
	should_flip(anim_name)
	play(anim_name + "_" + current_direction)

func flash_red()->void:
	modulate = Swatchton.RED_TOMATO
	for index in 4:
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
	Debuggerton.enable_print(self.name, dcolor)
	debug_animations = true
