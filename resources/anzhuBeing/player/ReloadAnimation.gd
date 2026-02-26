
class_name ReloadAnimation
extends Node


signal reloading_ended

@export_group("Debug")
@export var instant_reload: bool

var animation: String
var current_direction: String

@onready var parent: AnimatedSprite2D = get_parent()
@onready var grandparent: Player = parent.get_parent()
@onready var tres_frames: SpriteFrames = parent.sprite_frames
@onready var sfx_stuff: AudioStreamPlayer = $SfxStuff
@onready var sfx_thonk: AudioStreamPlayer = $SfxThonk


func _ready() -> void:
	grandparent.publish_event.connect(
		func(func_name:String, data:Variant=null):
			Lib.Observe.subscribe_to_event(self, func_name, data))


func _on_gun_reload_started() -> void:
	parent.speed_scale = 1 if not instant_reload else 100
	animation = "reload" + current_direction + "_"
	parent.play(animation + "Start")
	await parent.animation_finished
	sfx_stuff.play()
	for stuff: int in 10:
		parent.play(animation + "Stuff")
		await parent.animation_finished
	sfx_stuff.stop()
	for thonk: int in 2:
		parent.play(animation + "Thonk")
		await parent.animation_finished
		sfx_thonk.play()
	parent.play(animation + "Return_to_idle")
	await parent.animation_finished
	reloading_ended.emit()


func update_direction(incoming_direction: Dictionary) -> void:
	current_direction = Directon.get_personal_anim_direction(incoming_direction["Name"])
