
class_name RemoveParentOnStart
extends Node

@onready var parent: Node = get_parent()


func _ready() -> void:
	parent.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"debug"):
		parent.visible = !parent.visible
		print("DEBUGGED")
