extends AnimatedSprite2D #PlayerAnimations
@export var time_before_start_reload :float = 1.0
@export var time_before_end_reload :float = 1.0

var default_color :Color = Color("ffffff")
var red_color :Color = Color("b74132")
var is_colored :bool = false

var abilities :Node
var audio :Node2D
@onready var parent :AnzhuCharacter
@onready var directon :Directon = Directon
var current_direction :String = '_SIDE'
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		audio = node_dictionary['AudioManager']
		abilities = node_dictionary['Abilities']

func _on_animation_finished() -> void:
	should_flip()
	if animation == 'reload' + current_direction:
		set_animation('idle' + current_direction)
		abilities.can_do_stuff_again()

func start_reload_animation()->void:
	default_speed_scale() # Other Code results in a different speed scale
	stop_and_play('reload')
	await get_tree().create_timer(time_before_start_reload).timeout
	audio.audio_compilation['reload'].play()

func start_walk()->void:
	should_flip()
	play('walk' + current_direction)

func start_idle()->void:
	should_flip()
	play('idle' + current_direction)

func start_run()->void:
	should_flip()
	play('run' + current_direction)

func should_flip()->void:
	check_efficiency()
	current_direction = directon.anim_wants_to_know_where_we_looking()
	if current_direction == "_WEST":
		flip_h = true
	else:
		flip_h = false
	if current_direction == "_WEST" or current_direction == "_EAST":
		current_direction = "_SIDE"

func stop_and_play(anim_name :String)->void:
	stop()
	play(anim_name + current_direction)

func check_efficiency()->void:
	if abilities.is_efficient:
		default_speed_scale()
	else:
		speed_scale = 0.60

func default_speed_scale()->void:
	speed_scale = 1

func parent_stat_delivery(parental_unit :AnzhuCharacter)->void:
	parent = parental_unit

func was_just_hit()->void:
	modulate = red_color
	for index in 4:
		is_colored = !is_colored
		self_modulate = red_color if is_colored else default_color
		await get_tree().create_timer(.4).timeout
	modulate = default_color
	self_modulate = default_color
