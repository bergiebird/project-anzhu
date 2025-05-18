extends CanvasLayer #Framing.gd

var keep_controls :bool = false
@onready var left_panel_node :ColorRect = $LeftPanel
@onready var right_panel_node :ColorRect = $RightPanel
@onready var left_panel_children :Array[Node] = left_panel_node.get_children()
@onready var right_panel_children :Array[Node] = right_panel_node.get_children()
@onready var console :RichTextLabel = right_panel_node.get_node('Console')
@onready var ui_controls :UiControls = %UiControls
@onready var vbox :VBoxContainer = %VBoxContainer
@onready var invis :CheckButton = %InvisibleWalls

func _ready() -> void:
	visible = true
	for child:Node in vbox.get_children():
		left_panel_children.append(child)
	Inputon.cursor_movement_report.connect(ui_visibility)
	ui_visibility(false)



func ui_visibility(has_visible :bool):
	for child in left_panel_children:
		if child is UiControls and keep_controls:

			child.visible = true
			continue
		child.visible = has_visible
	for child in right_panel_children:
		child.visible = has_visible


func _on_reset_pressed():
	Signalton.reload_current_scene()
func _on_elevation_pressed():
	Signalton.toggle_debug_elevation.emit()
func _on_quit_pressed():
	get_tree().quit()
func _on_invisible_walls_toggled(_toggled_on: bool):
	Signalton.toggle_debug_invisible.emit()
func _on_keep_controls_toggled(toggled_on: bool):
	keep_controls = toggled_on

#region DEBUG
@export_group("Debug")
@export var debug :bool = false
#endregion
