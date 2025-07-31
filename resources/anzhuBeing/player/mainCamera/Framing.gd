
class_name Framing
extends CanvasLayer

@export var keep_controls: bool = false

var is_text_displaying: bool

@onready var console: Console = %Console
@onready var controls_button: Node = %KeepControls
@onready var both_panels_children: Array[Node] = []

func _ready():
	both_panels_children.append_array($EastPanel.get_children())
	both_panels_children.append_array($WestPanel.get_children())
	for child:Node in get_children():
		if child is ColorRect:
			child.color = Color.BLACK
	console.text_on_screen.connect(func(bol:bool): is_text_displaying = bol)
	visible = true
	Inputon.cursor_movement_report.connect(ui_visibility)
	ui_visibility(false)

func ui_visibility(has_visible: bool):
	for child in both_panels_children:
		child.visible = has_visible
		if child is UiControls and keep_controls:
			child.visible = true
	if keep_controls and controls_button.button_pressed != true:
		controls_button.button_pressed = true

func _on_reset_pressed():
	Sgnl.reload_current_scene()

func _on_elevation_pressed():
	Sgnl.toggle_debug_elevation.emit()

func _on_quit_pressed():
	get_tree().quit()

func _on_invisible_walls_toggled(_toggled_on: bool):
	Sgnl.toggle_debug_invisible.emit()

func _on_keep_controls_toggled(toggled_on: bool):
	keep_controls = toggled_on



#region DEBUG
@export_group("Debug")
@export var debug :bool = false
#endregion
