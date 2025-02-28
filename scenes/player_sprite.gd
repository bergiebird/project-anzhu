extends AnimatedSprite2D
@export var time_before_start_reload :float = 1.0
@export var time_before_end_reload :float = 1.0
@onready var sfx_fire = %SfxFire
@onready var sfx_reload = %SfxReload
@onready var parent = get_parent()
var current_direction :String = '_SIDE'


func _ready()->void:
	Signalton.gunshot.connect(start_gun)

func _on_animation_finished() -> void:
	should_flip()
	if animation == 'reload' + current_direction:
		set_animation('idle' + current_direction)
		parent.can_do_stuff_again()

func start_gun()->void:
	default_speed_scale()
	stop_and_play('reload')
	sfx_fire.play()
	await get_tree().create_timer(time_before_start_reload).timeout
	sfx_reload.play()


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
	current_direction = Enumerton.anim_wants_to_know_where_we_looking()
	if current_direction == "_WEST": flip_h = true
	else:                            flip_h = false
	if current_direction == "_WEST" or current_direction == "_EAST": current_direction = "_SIDE"

func stop_and_play(anim_name :String)->void:
	stop()
	play(anim_name + current_direction)

func check_efficiency()->void:
	if parent.is_efficient:
		default_speed_scale()
	else:
		speed_scale = 0.60

func default_speed_scale()->void:
	speed_scale=1
