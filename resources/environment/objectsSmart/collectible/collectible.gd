extends StaticBody2D
class_name Collectible

signal publisher_null(String)
signal publisher_one(String, one:Variant)
signal publisher_two(String, one:Variant, two:Variant)

@export var png_folder :String = "res://resources/environment/objectsSmart/collectible/logs/"
@onready var sfx_collect :AudioStreamPlayer = $SfxCollect

func _ready():
	publisher_null.connect(func(func_name:String): Observerton.subscribe_null(self, func_name))
	sfx_collect.finished.connect(func(): queue_free())

func interacted():
	$Interactible.queue_free()
	$Mask.queue_free()
	$Sprite2D.queue_free()
	await get_tree().create_timer(0.1).timeout
	sfx_collect.play()
