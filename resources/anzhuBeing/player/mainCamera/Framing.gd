extends CanvasLayer #Framing.gd
@onready var left_panel_node :ColorRect = $LeftPanel
@onready var left_panel_children :Array[Node] = left_panel_node.get_children()
@onready var right_panel_children :Array[Node] = $RightPanel.get_children()
@onready var vbox :VBoxContainer = %VBoxContainer

func _ready() -> void:
	visible = true
	for child:Node in vbox.get_children():
		left_panel_children.append(child)
	Inputon.cursor_movement_report.connect(ui_visibility)
	ui_visibility(false)


func ui_visibility(has_visible :bool)->void:
	for child in left_panel_children:
		child.visible = has_visible
	for child in right_panel_children:
		child.visible = has_visible

func _on_reset_pressed():
	Signalton.reload_current_scene()
func _on_elevation_pressed():
	Signalton.toggle_debug_elevation.emit()
func _on_invisible_toggled():
	Signalton.toggle_debug_invisible.emit()
func _on_quit_pressed():
	get_tree().quit()
