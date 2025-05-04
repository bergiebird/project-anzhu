class_name MainCamera extends Camera2D #MainCamera.gd

@onready var player_ui :Control = $PlayerUi
@onready var reload_button :Button = player_ui.get_node("Reload_Button")

func _ready()->void:
	visible = true
	Debuggerton.signal_checker([
		Inputon.cursor_visibility.connect(_on_cursor_visibility_changed),
		reload_button.pressed.connect(_reload_scene_on_press)
	], debug)


func _reload_scene_on_press() -> void:
	Signalton.reload_scene.emit()

func _on_cursor_visibility_changed(has_visibility :bool)->void:
	print('visibility set to: ', has_visibility)
	player_ui.visible = has_visibility


###
##	DEBUG
###
@export_group('Debug')
@export var debug :bool = false
