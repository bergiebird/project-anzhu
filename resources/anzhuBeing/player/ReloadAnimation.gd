class_name ReloadAnimation extends Node #ReloadAnimation.gd

const START :String = "Start"
const STUFF :String = "Stuff"
const THONK :String = "Thonk"
const RETURN_TO_IDLE :String = "Return_to_idle"
const STUFF_8_TIMES :int = 10
const THONK_2_TIMES :int = 2
var animation :String
var current_direction :String
@onready var parent :AnimatedSprite2D = get_parent()
@onready var grandparent :Player = parent.get_parent()
@onready var tres_frames :SpriteFrames = parent.sprite_frames
@onready var sfx_stuff :AudioStreamPlayer = $SfxStuff
@onready var sfx_thonk :AudioStreamPlayer = $SfxThonk

func _ready():
	grandparent.observer_one.connect(func(func_name, one :Variant): Observerton.match_one(self, func_name, one))

func start_routine():
	parent.speed_scale = 1
	animation = "reload" + current_direction + "_"
	parent.stop()
	parent.play(animation + START)
	await parent.animation_finished
	sfx_stuff.play()
	for stuff in STUFF_8_TIMES:
		parent.stop()
		parent.play(animation + STUFF)
		await parent.animation_finished
	sfx_stuff.stop()
	for thonk in THONK_2_TIMES:
		parent.stop()
		parent.play(animation + THONK)
		await parent.animation_finished
		sfx_thonk.play()
	parent.stop()
	parent.play(animation + RETURN_TO_IDLE)
	await parent.animation_finished
	parent.reload_animation_finished()

func direction_changed_with_name(incoming_name :String):
	current_direction = Directon.get_personal_anim_direction(incoming_name)
