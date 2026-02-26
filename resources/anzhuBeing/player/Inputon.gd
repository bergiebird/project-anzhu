extends Node
#Inputon.gd

var player :Player:
	set(value):
		if player != value:
			player = value
var shot_db: float

func _ready():
	Sgnl.player_reference.connect(func(ref :Player)->void: player = ref)
	set_player_cursors()
#region #=======================================================================================# KEYBOARD
func look_direction(direction: String)->bool:
	return true if Input.is_action_pressed(Directon.get_aim(direction)) else false

func aim(direction: String)->bool:
	return Input.is_action_pressed("aim_" + direction)

func inverse_move(direction: String)->bool:
	return move(Directon.OPPOSITE[direction])

func move(direction: String)->bool:
	return Input.is_action_pressed("move_" + direction)

func inverse_aim(direction: String)->bool:
	return aim(Directon.OPPOSITE[direction])

func jump_pressed()->bool:
	return Input.is_action_just_pressed('jump')

func jump_released()->bool:
	return Input.is_action_just_released("jump")

func modifier()->bool:
	return Input.is_action_just_pressed('spacebar')

func gun_reload()->bool:
	return Input.is_action_just_pressed('gun')

func escape()->bool:
	return Input.is_action_just_released("esc")
#endregion #====================================================================================# KEYBOARD
#region #=======================================================================================# MOUSE
signal cursor_movement_report(bol: bool)
const CURSOR_HOTSPOT: Vector2 = Vector2(14,4)

var current_resting_cursor :DisplayServer.CursorShape

@onready var sprite_idle :Texture2D = preload("uid://c5iwysswhjf06")
@onready var sprite_click :Texture2D = preload("uid://dwct5s8apk8eh")
@onready var sprite_inspect :Texture2D = preload("uid://dyeo6vbhfj0rt")

func set_player_cursors():
	Input.set_custom_mouse_cursor(sprite_idle, Input.CURSOR_ARROW, CURSOR_HOTSPOT)
	Input.set_custom_mouse_cursor(sprite_inspect, Input.CURSOR_IBEAM, CURSOR_HOTSPOT)
	Input.set_custom_mouse_cursor(sprite_click, Input.CURSOR_POINTING_HAND, CURSOR_HOTSPOT)
	set_cursor_to_point()

func hide_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cursor_movement_report.emit(false) # Godot doesn't offer a signal that emits on cursor visibility changed

func reveal_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	cursor_movement_report.emit(true)

func set_cursor_to_resting():
	DisplayServer.cursor_set_shape(current_resting_cursor)

func set_cursor_to_point():
	current_resting_cursor = DisplayServer.CURSOR_ARROW
	DisplayServer.cursor_set_shape(current_resting_cursor)

func set_cursor_to_ibeam():
	current_resting_cursor = DisplayServer.CURSOR_IBEAM
	DisplayServer.cursor_set_shape(current_resting_cursor)

func set_cursor_to_click():
	DisplayServer.cursor_set_shape(DisplayServer.CURSOR_POINTING_HAND)



func left_mouse_release()->bool:
	return Input.is_action_just_released("left_click")
#endregion #====================================================================================# MOUSE
