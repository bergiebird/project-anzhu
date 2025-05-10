class_name Collectible extends StaticBody2D

@export var png_folder :String = "res://resources/environment/objectsSmart/collectible/logs/"
@onready var interactible :Interactible = $Interactible
@onready var mask :Mask = $Mask
@onready var sprite :Sprite2D = $Sprite2D
@onready var sfx_collect :AudioStreamPlayer = $SfxCollect

func _ready() -> void:
	interactible.interacted.connect(collected)

func collected()->void:
	interactible.queue_free()
	mask.queue_free()
	sprite.queue_free()
	await get_tree().create_timer(0.1).timeout
	sfx_collect.play()
	await sfx_collect.finished
	queue_free()
