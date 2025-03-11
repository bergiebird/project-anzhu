@icon("res://warehouse/_icons/node_2D/icon_audio.png")
class_name AudioManager extends Node2D #AudioManager.gd

var audio_compilation :Dictionary[String, Node]

func _ready()->void:
	for child in get_children():
		audio_compilation[child.name] = child
