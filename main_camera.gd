class_name MainCamera extends Camera2D #MainCamera.gd

@onready var player_ui :Control = $PlayerUi
@onready var reload_button :Button = player_ui.get_node("Reload_Button")

func _ready()->void:
	visible = true
	Inputon.cursor_visibility.connect(_on_cursor_visibility_changed)
	reload_button.pressed.connect(_reload_scene_on_press)


func _reload_scene_on_press() -> void:
	Signalton.reload_scene.emit()

func _on_cursor_visibility_changed(is_visible :bool)->void:
	print('visibility set to: ', is_visible)
	player_ui.visible = is_visible
