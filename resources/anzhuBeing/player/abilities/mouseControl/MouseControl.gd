@icon("res://resources/anzhuBeing/player/abilities/mouseControl/icon_search.png")
extends Ability #MouseControl.gd
const TIMER_RESETTED :float = 0.0
@export var mouse_idle_threshold :float = 2.0

var mouse_idle_timer :float = TIMER_RESETTED:
	set(value): if value != mouse_idle_timer:
		mouse_idle_timer = value                            # Set value
		match Input.get_mouse_mode():                       # Checks the current mode of cursor
			Input.MOUSE_MODE_VISIBLE:                        # On visibility
				if mouse_idle_timer >= mouse_idle_threshold:  #
					Inputon.hide_cursor()
			Input.MOUSE_MODE_HIDDEN:
				if mouse_idle_timer == TIMER_RESETTED:
					Inputon.reveal_cursor()

var current_cursor :Texture2D:
	set(value): if value!=current_cursor:
		current_cursor = value
		execute_click()                                  # On the changing of cursors, play Sfx and start timer
		Input.set_custom_mouse_cursor(current_cursor)    # Set the cursor to the new value
var current_mouse_position :Vector2
@onready var sfx_click :AudioStreamPlayer = $MenuClick
@onready var timer_reset :Timer = $ResetTimer
@onready var sprite_idle :Texture2D = preload("uid://c5iwysswhjf06")
@onready var sprite_click :Texture2D = preload("uid://dwct5s8apk8eh")
@onready var previous_mouse_position :Vector2 = get_viewport().get_mouse_position()

func _ready()->void:
	current_cursor = sprite_idle
	Inputon.hide_cursor()
	timer_reset.timeout.connect(func()->void:current_cursor = sprite_idle)



func _physics_process(delta :float)->void:
	current_mouse_position = get_viewport().get_mouse_position()  # Every frame we check for the mouse's position
	if current_mouse_position != previous_mouse_position:         # If the position is new
		mouse_idle_timer = TIMER_RESETTED                          # We reset the timer to 0
		previous_mouse_position = current_mouse_position           # Now we set the previous position
	else:                                                         # On other hand, if the position is the same
		mouse_idle_timer += delta                                  # Increment the idle timer

func _input(event :InputEvent)->void:
	if event is InputEventMouseButton and Inputon.left_mouse_release() or Inputon.escape():
		current_cursor = sprite_click
		if Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN:
			mouse_idle_timer = TIMER_RESETTED


func execute_click()->void:
	if current_cursor == sprite_click: # This prevents multiple executions
		sfx_click.play()
		timer_reset.start()
