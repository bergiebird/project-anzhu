extends Control
class_name UiControls

var labels: Dictionary[String,Label]

@onready var pressed: FontFile = preload("uid://7nmwvli4a0me")
@onready var unpressed: FontFile = preload("uid://cydaeja4giwbn")
@onready var first_time: bool = true


func _ready():
	for child:Label in get_children():
		labels[child.name] = child


func _input(event: InputEvent):
	if event is InputEventKey:
		var key_string = OS.get_keycode_string(event.keycode)
		learn_what_is_being_inputted(event)
		if key_string in labels:
			if event.pressed:
				labels[key_string].add_theme_font_override("font", pressed)
			else:
				labels[key_string].add_theme_font_override("font", unpressed)


func learn_what_is_being_inputted(event: InputEvent):
	if first_time:
		first_time = false
		printt(DisplayServer.keyboard_get_layout_name(DisplayServer.keyboard_get_current_layout()))
	printt(DisplayServer.keyboard_get_keycode_from_physical(event.keycode))
	printt("key_string:",OS.get_keycode_string(event.keycode))


func set_inputs_to_colemak(_toggle): #TODO
	pass
