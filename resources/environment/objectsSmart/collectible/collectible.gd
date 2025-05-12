class_name Collectible extends StaticBody2D

signal observer_null(String)
signal observer_one(String, one:Variant)
signal observer_two(String, one:Variant, two:Variant)

@export var png_folder :String = "res://resources/environment/objectsSmart/collectible/logs/"
@onready var interactible :Interactible = $Interactible
@onready var mask :Mask = $Mask
@onready var sprite :Sprite2D = $Sprite2D
@onready var sfx_collect :AudioStreamPlayer = $SfxCollect

func _ready() -> void:
	observer_null.connect(func(func_name): Observerton.match_null(self, func_name))
	observer_one.connect(func(func_name, one :Variant): Observerton.match_one(self, func_name, one))
	observer_two.connect(func(func_name, one :Variant, two :Variant): Observerton.match_two(self, func_name, one, two))

func interacted()->void:
	interactible.queue_free()
	mask.queue_free()
	sprite.queue_free()
	await get_tree().create_timer(0.1).timeout
	sfx_collect.play()
	await sfx_collect.finished
	queue_free()
