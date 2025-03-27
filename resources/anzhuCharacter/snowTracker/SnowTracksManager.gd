extends Node2D #Tracks.gd

@onready var tracktype :Dictionary[String,Node]

func _ready()->void:
	for child in get_children():
		tracktype[child.name] = child
	Libraryton.set_tracks(tracktype)
