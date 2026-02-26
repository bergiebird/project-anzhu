@icon("res://resources/anzhuBeing/player/abilities/mouseControl/icon_search.png")

extends Ability
class_name MouseControl

@onready var can_click: bool = true
@onready var previous_mouse_position: Vector2 = get_viewport().get_mouse_position()
@onready var mouse_idle_timer: Timer = $MouseIdleTimer
@onready var menu_click_audio: AudioStreamPlayer = $MenuClick
@onready var click_reset_timer: Timer = $ClickResetTimer

func __ready():
	Inputon.set_player_cursors() # Initializer
	Inputon.hide_cursor()

func _process(_delta: float) -> void:
	var current_mouse_position: Vector2 = get_viewport().get_mouse_position()
	if current_mouse_position != previous_mouse_position:
		previous_mouse_position = current_mouse_position
		mouse_moved()

func _input(event: InputEvent) -> void:
	if event is InputEventMouse or Inputon.escape():
		mouse_moved()
		if can_click:
			if Inputon.left_mouse_release():
				execute_click()

func execute_click() -> void:
	if can_click:
		can_click = false
		Inputon.set_cursor_to_click()
		menu_click_audio.play()
		click_reset_timer.start()

func mouse_moved() -> void:
	mouse_idle_timer.start()
	Inputon.reveal_cursor()


func _on_click_reset_timer_timeout() -> void:
	can_click = true
	Inputon.set_cursor_to_resting()


func _on_mouse_idle_timer_timeout() -> void:
	Inputon.hide_cursor()
