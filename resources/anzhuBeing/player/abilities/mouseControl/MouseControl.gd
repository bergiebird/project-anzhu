@icon("res://resources/anzhuBeing/player/abilities/mouseControl/icon_search.png")
extends Ability #MouseControl.gd
const TIMER_RESETTED :float = 0.0
@export var mouse_idle_threshold :float = 2.0

var mouse_idle_timer :float = TIMER_RESETTED:
	set(value): if value != mouse_idle_timer:
		mouse_idle_timer = value
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_VISIBLE:
				if mouse_idle_timer >= mouse_idle_threshold:
					Inputon.hide_cursor()
			Input.MOUSE_MODE_HIDDEN:
				if mouse_idle_timer == TIMER_RESETTED:
					Inputon.reveal_cursor()

var current_cursor :Texture2D:
	set(value): if value!=current_cursor:
		current_cursor = value
		execute_click()
		Input.set_custom_mouse_cursor(current_cursor)
var current_mouse_position :Vector2
@onready var sfx_click :AudioStreamPlayer = $MenuClick
@onready var timer_reset :Timer = $ResetTimer
@onready var sprite_idle :Sprite2D = $CursorImage_Idle
@onready var sprite_click :Sprite2D = $CursorImage_Click
@onready var previous_mouse_position :Vector2 = get_viewport().get_mouse_position()

func _ready()->void:
	current_cursor = sprite_idle.texture
	Inputon.hide_cursor()
	timer_reset.timeout.connect(func()->void:current_cursor = sprite_idle.texture)



func process_ability(delta :float)->void:
	current_mouse_position = get_viewport().get_mouse_position()
	if current_mouse_position != previous_mouse_position:
		mouse_idle_timer = TIMER_RESETTED
		previous_mouse_position = current_mouse_position
	else:
		mouse_idle_timer += delta
		previous_mouse_position = current_mouse_position

func _input(event :InputEvent)->void:
	if event is InputEventMouseButton and Inputon.left_mouse_release() or Inputon.escape():
		current_cursor = sprite_click.texture
		if Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN:
			mouse_idle_timer = TIMER_RESETTED


func execute_click()->void:
	if current_cursor == sprite_click.texture: #This prevents multiple executions
		sfx_click.play()
		timer_reset.start()
