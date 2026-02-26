
class_name Framing
extends CanvasLayer

@export var keep_controls: bool = false

@onready var controls_button: Node = %KeepControls
@onready var both_panels_children: Array[Node] = []
@onready var tree: SceneTree = get_tree()


func _ready() -> void:
	both_panels_children.append_array($EastPanel.get_children())
	both_panels_children.append_array($WestPanel.get_children())
	for child: Node in get_children():
		if child is ColorRect:
			child.color = Color.BLACK
	visible = true
	Inputon.cursor_movement_report.connect(ui_visibility)
	ui_visibility(false)


func ui_visibility(has_visible: bool) -> void:
	for child: Node in both_panels_children:
		child.visible = has_visible
		if child is UiControls and keep_controls:
			child.visible = true
	if keep_controls and controls_button.button_pressed != true:
		controls_button.button_pressed = true


func _on_reset_pressed() -> void:
	Sgnl.reload_current_scene()


func _on_elevation_pressed() -> void:
	Sgnl.toggle_debug_elevation.emit()


func _on_quit_pressed() -> void:
	tree.quit()


func _on_invisible_walls_toggled(toggled_on: bool) -> void:
	Sgnl.toggle_debug_invisible.emit(toggled_on)


func _on_keep_controls_toggled(toggled_on: bool) -> void:
	keep_controls = toggled_on


func _on_pause_game_toggled(toggled_on: bool) -> void:
	tree.paused = toggled_on


func _on_disable_music_toggled(toggled_on: bool) -> void:
	Sgnl.music_muted.emit(toggled_on)
