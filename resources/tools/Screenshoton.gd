
#Screenshoton.gd
extends Node


@onready var screenshot_folder: String = "res://warehouse/_screenshots/only_screenshot.png"
@onready var inform: String = '[wave]Screenshot taken! You only get one, so far. . .[/wave]'


func _ready()->void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(_event: InputEvent)->void:
	if OS.is_debug_build() and Input.is_action_just_pressed('tab'):
		print_rich(inform)
		get_viewport().get_texture().get_image().save_png(screenshot_folder)
