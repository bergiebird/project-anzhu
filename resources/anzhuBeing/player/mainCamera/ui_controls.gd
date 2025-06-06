extends Control
class_name UiControls

var labels :Dictionary[String,Label]

@onready var pressed :FontFile = preload("uid://7nmwvli4a0me")
@onready var unpressed :FontFile = preload("uid://cydaeja4giwbn")

func _ready():
	for child:Label in get_children():
		labels[child.name] = child

func _input(event: InputEvent):
	if event is InputEventKey:
		var key_string = OS.get_keycode_string(event.keycode)
		if key_string in labels:
			if event.pressed:
				labels[key_string].add_theme_font_override("font", pressed)
			else:
				labels[key_string].add_theme_font_override("font", unpressed)




func set_inputs_to_colemak(_toggle):
	pass
