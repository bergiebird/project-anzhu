
class_name CollectibleSprite
extends Sprite2D

@onready var parent: StaticBody2D = get_parent()


func _ready() -> void:
	var folder: DirAccess = DirAccess.open(parent.png_folder)
	folder.list_dir_begin()
	var file_name: String
	var count: int = 0
	var end_count: int = Libraryton.rng.randi_range(1,10)
	while true: # Put the last if statement here
		file_name = folder.get_next()
		if file_name.ends_with(".png"):
			count += 1
			if count >= end_count:
				break
	folder.list_dir_end()
	texture = load(parent.png_folder + file_name)
