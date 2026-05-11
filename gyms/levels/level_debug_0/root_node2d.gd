@tool

class_name RootNode2D
extends Node2D

@export var level_name: StringName

@warning_ignore_start("unused_private_class_variable")
## Adds all items from the Array, for editing purposes
@export_tool_button("Build From Checklist") var _build = _build_from_checklist
## Removes all items from the Array, for cleaning purposes
@export_tool_button("Clear Children") var _clear = _clear_children
@warning_ignore_restore("unused_private_class_variable")


## order: SNOW, TRACKS, SNOW OVERLAP, OCEAN, ICE, WALLS, ENTITIES, FOGS, TOOLS
@export var checklist: Array[PackedScene]


func _ready() -> void:

	assert(checklist.size() == 9)
	_build_from_checklist()



func _build_from_checklist() -> void:
	_clear_children()
	for i: int in checklist.size():
		var new_child_node: Node = checklist[i].instantiate()
		add_child(new_child_node)
		move_child(new_child_node, i)
	for child: Node in get_children():
		child.global_position = Vector2.ZERO


func _clear_children() -> void:
	for child: Node in get_children():
		child.queue_free()
