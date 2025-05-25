extends Control
class_name UiControls

var dict :Dictionary[String,Label]

@onready var pressed :FontFile = preload("uid://7nmwvli4a0me")
@onready var unpressed :FontFile = preload("uid://cydaeja4giwbn")


func _ready():
	for child:Label in get_children():
		dict[child.name] = child

func _input(event: InputEvent):
	if event is InputEventKey:
		var key_string = OS.get_keycode_string(event.keycode)
		if key_string in dict:
			if event.pressed:
				dict[key_string].add_theme_font_override("font", pressed)
			else:
				dict[key_string].add_theme_font_override("font", unpressed)
