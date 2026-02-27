
class_name RootNode2D
extends Node2D


func _ready():
	for child: Node in get_children():
		child.global_position = Vector2.ZERO
