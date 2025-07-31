
class_name RemoveParentOnStart
extends Node


func _ready() -> void:
	get_parent().queue_free()
