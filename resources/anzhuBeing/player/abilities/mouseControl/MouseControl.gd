@icon("res://resources/anzhuBeing/player/abilities/mouseControl/icon_search.png")
class_name MouseControl extends Ability

@onready var can_click :bool = true
@onready var sfx_click :AudioStreamPlayer = $MenuClick
@onready var click_reset_timer :Timer = $ClickResetTimer
@onready var idle_mouse_timer :Timer = $MouseIdleTimer
@onready var sprite_idle :Texture2D = preload("uid://c5iwysswhjf06")
@onready var sprite_click :Texture2D = preload("uid://dwct5s8apk8eh")
@onready var previous_mouse_position :Vector2 = get_viewport().get_mouse_position()


func _ready()->void:
	Input.set_custom_mouse_cursor(sprite_idle)
	Inputon.hide_cursor()
	click_reset_timer.timeout.connect(click_restted)
	idle_mouse_timer.timeout.connect(mouse_idled_too_long)

func _process(_delta :float)->void:
	var current_mouse_position :Vector2 = get_viewport().get_mouse_position()  # Every frame we check for the mouse's position
	if current_mouse_position != previous_mouse_position:         # If the position is new
		Inputon.reveal_cursor()
		idle_mouse_timer.stop()
		idle_mouse_timer.start()
		previous_mouse_position = current_mouse_position

func _input(event :InputEvent)->void:
	if event is InputEventMouseButton and Inputon.left_mouse_release() and can_click or Inputon.escape() and can_click:
		execute_click()

func execute_click()->void:
	if can_click:
		can_click = false
		Input.set_custom_mouse_cursor(sprite_click)
		sfx_click.play()
		click_reset_timer.start()
		idle_mouse_timer.stop()
		idle_mouse_timer.start()

func mouse_idled_too_long():
		match Input.get_mouse_mode():
			Input.MOUSE_MODE_VISIBLE:
					Inputon.hide_cursor()
			Input.MOUSE_MODE_HIDDEN:
					Inputon.reveal_cursor()

func click_restted():
	can_click = true
	Input.set_custom_mouse_cursor(sprite_idle)
