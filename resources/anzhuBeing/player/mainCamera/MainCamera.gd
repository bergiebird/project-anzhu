class_name MainCamera extends Camera2D #MainCamera.gd

@onready var player_ui :Control = $PlayerUi

func _ready()->void:
	visible = true
	Inputon.cursor_movement_report.connect(_on_cursor_visibility_changed)
	_on_cursor_visibility_changed(false)


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
