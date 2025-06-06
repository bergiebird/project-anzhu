extends StaticBody2D
class_name Collectible

signal publish_event(String, Variant)

@export var png_folder :String = "res://resources/environment/objectsSmart/collectible/logs/"
@onready var sfx_collect :AudioStreamPlayer = $SfxCollect

func _ready():
	publish_event.connect(
		func(func_name:String, data:Variant=null): L.Observe.subscribe_to_event(self, func_name, data))
	for child in get_children():
		if child.get_script():
			publish_event.connect(
				func(func_name:String, data:Variant=null): L.Observe.subscribe_to_event(child, func_name, data))
	sfx_collect.finished.connect(func(): queue_free())

func interacted():
	$Interactible.queue_free()
	$Mask.queue_free()
	$Sprite2D.queue_free()
	await get_tree().create_timer(0.1).timeout
	sfx_collect.play()
