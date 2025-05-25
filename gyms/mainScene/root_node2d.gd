extends Node2D
class_name RootNode2D

func _ready():
	for child in get_children():
		child.global_position = Vector2.ZERO
