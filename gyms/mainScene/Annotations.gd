
## To handle all visual note taking for developers, this script simply deletes the notes
## on start. Further extension is available.

extends Control
class_name Annotations


func _ready() -> void:
	queue_free()
