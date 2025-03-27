extends Node #Screenshoton.gd

func _ready()->void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if OS.is_debug_build() and Input.is_action_just_pressed('screenshot'): #tab
		print_rich('[wave]Screenshot taken! You only get one, so far. . .[/wave]')
		get_viewport().get_texture().get_image().save_png("res://warehouse/_screenshots/only_screenshot.png")
