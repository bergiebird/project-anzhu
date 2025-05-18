class_name Collectible extends StaticBody2D

signal publisher_null(String)
signal publisher_one(String, one:Variant)
signal publisher_two(String, one:Variant, two:Variant)

@export var png_folder :String = "res://resources/environment/objectsSmart/collectible/logs/"
@onready var sfx_collect :AudioStreamPlayer = $SfxCollect

func _ready() -> void:
	publisher_null.connect(func(func_name): Observerton.subscribe_null(self, func_name))

func interacted()->void:
	$Interactible.queue_free()
	$Mask.queue_free()
	$Sprite2D.queue_free()
	await get_tree().create_timer(0.1).timeout
	sfx_collect.play()
	await sfx_collect.finished
	queue_free()
