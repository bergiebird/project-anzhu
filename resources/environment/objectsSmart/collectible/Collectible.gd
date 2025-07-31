@icon("res://warehouse/icons/node_2D/icon_coin.png")

extends StaticBody2D
class_name Collectible

@export var png_folder: String = "res://resources/environment/objectsSmart/collectible/logs/"

enum CollectibleType {WOOD} # Heh, will we have others?

@export var collectible_type: CollectibleType

@onready var mask: Mask = $Mask
@onready var interactible: Interactible = $Interactible
@onready var sfx_collect: AudioStreamPlayer = $SfxCollect
@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	interactible.interacted.connect(_interacted)
	sfx_collect.finished.connect(func(): queue_free())


func _interacted():
	match collectible_type:
		CollectibleType.WOOD:
			wood_interacted()


func wood_interacted():
	interactible.queue_free()
	mask.queue_free()
	sprite.queue_free()
	await get_tree().create_timer(0.1).timeout
	sfx_collect.play()
