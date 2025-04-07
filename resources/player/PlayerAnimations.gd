extends AnimatedSprite2D #PlayerAnimations.gd
@export var animations_reloads_reload_time :float = 0.5
@export_group('Debug')
@export var debug_animations :bool = false
@export var debugger_color :Color = Color("e67a84")
var default_color :Color = Color("ffffff")
var red_color :Color = Color("b74132")
var is_colored :bool = false
var abilities :Node
var audio :Node2D
var current_direction :String = '_SIDE'
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		audio = node_dictionary['AudioManager']
		abilities = node_dictionary['Abilities']
@onready var dcolor = debugger_color.to_html()
@onready var parent :AnzhuCharacter = get_parent()
@onready var D :Directon = Directon

func _ready()->void:
	parent.was_struck.connect(flash_red)
	animation_finished.connect(reload_animation_finished)

func reload_animation_finished()->void:
	if animation == 'reload' + current_direction:
		just_play('idle')
		speed_scale = 1
		audio.audio_dictionary['reload'].pitch_scale = 0.7
		abilities.can_do_stuff_again()
		abilities.is_reloading = false

func start_reload_animation()->void:
	stop()
	just_play('reload')
	speed_scale = 1
	await get_tree().create_timer(animations_reloads_reload_time).timeout
	audio.audio_dictionary['reload'].play()

func should_flip(anim_name :String)->void:
	if abilities.is_efficient:
		speed_scale = 1
	else:
		speed_scale = 0.60
	current_direction = D.anim_wants_to_know_where_we_looking()
	if current_direction == "_WEST":
		flip_h = true
	else:
		flip_h = false
	if current_direction == "_WEST" or current_direction == "_EAST":
		current_direction = "_SIDE"

func just_play(anim_name :String)->void:
	should_flip(anim_name)
	play(anim_name + current_direction)

func flash_red()->void:
	modulate = red_color
	for index in 4:
		is_colored = !is_colored
		self_modulate = red_color if is_colored else default_color
		await get_tree().create_timer(.4).timeout
	modulate = default_color
	self_modulate = default_color

func debug()->void:
	Debuggerton.enable_print(self.name, dcolor)
	debug_animations = true
