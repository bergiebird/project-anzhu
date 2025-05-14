class_name UiControls extends Control

var dict :Dictionary[String,Label]

@onready var pressed :FontFile = preload("uid://ca5g8gcgl3dw")
@onready var unpressed :FontFile = preload("res://warehouse/fonts/[16] Enter Input/local/Enter-Input-All/Enter_Input_Dark.ttf")


func _ready() -> void:
	for child:Label in get_children():
		dict[child.name] = child

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_string = OS.get_keycode_string(event.keycode)
		if key_string in dict:
			if event.pressed:
				dict[key_string].add_theme_font_override("font", pressed)
			else:
				dict[key_string].add_theme_font_override("font", unpressed)
