
class_name ReloadAnimation
extends Node

var animation: String
var current_direction: String

@onready var parent: AnimatedSprite2D = get_parent()
@onready var grandparent: Player = parent.get_parent()
@onready var tres_frames: SpriteFrames = parent.sprite_frames
@onready var sfx_stuff: AudioStreamPlayer = $SfxStuff
@onready var sfx_thonk: AudioStreamPlayer = $SfxThonk

func _ready():
	grandparent.publish_event.connect(func(func_name:String, data:Variant=null):Lib.Observe.subscribe_to_event(self, func_name, data))

func start_routine():
	parent.speed_scale = 1 if not instant_reload else 100
	animation = "reload" + current_direction + "_"
	parent.stop()
	parent.play(animation + "Start")
	await parent.animation_finished
	sfx_stuff.play()
	for stuff in 10:
		parent.stop()
		parent.play(animation + "Stuff")
		await parent.animation_finished
	sfx_stuff.stop()
	for thonk in 2:
		parent.stop()
		parent.play(animation + "Thonk")
		await parent.animation_finished
		sfx_thonk.play()
	parent.stop()
	parent.play(animation + "Return_to_idle")
	await parent.animation_finished
	parent.reload_animation_finished()

func update_direction(incoming_direction :Dictionary):
	current_direction = Directon.get_personal_anim_direction(incoming_direction["Name"])


@export_group("Debug")
@export var instant_reload :bool
