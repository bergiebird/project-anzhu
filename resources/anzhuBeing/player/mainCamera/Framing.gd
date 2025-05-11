extends CanvasLayer #Framing.gd

@onready var left_panel_children :Array[Node] = $LeftPanel.get_children()
@onready var right_panel_children :Array[Node] = $RightPanel.get_children()
@onready var reset_button :Button = %Reset

func _ready() -> void:
	left_panel_children.append(reset_button)
	reset_button.pressed.connect(_on_reset_pressed)
	Inputon.cursor_movement_report.connect(ui_visibility)
	ui_visibility(false)

func _on_reset_pressed():
	Signalton.reload_current_scene()

func ui_visibility(has_visible :bool)->void:
	for child in left_panel_children:
		child.visible = has_visible
	for child in right_panel_children:
		child.visible = has_visible
