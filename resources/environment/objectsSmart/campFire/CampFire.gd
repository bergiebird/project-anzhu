@icon("res://resources/environment/objectsSmart/campFire/campfire.png")
class_name CampFire extends StaticBody2D #CampFire.gd

signal observer_null(method_name :String)
signal observer_one(method_name :String, one :Variant)
signal observer_two(method_name :String, one :Variant, two :Variant)
signal observer_three(method_name :String, one :Variant, two :Variant, three :Variant)

@export var min_light :float = 0.1
@export var max_light :float = 1.0
@export var is_lit :bool:
	set(value):
		is_lit = value
		fire_light.visible = is_lit
		if is_lit:
			fire_anim.animation = "lit"
			sfx_crackle.play()
			bgm_camp_fire.play()
		else:
			fire_anim.animation = "unlit"
			bgm_camp_fire.stop()
			sfx_crackle.stop()
var tween :Tween
var time_dictionary :Dictionary
@export var player :Player
@onready var fire_anim :AnimatedSprite2D = $CampFireAnimation
@onready var fire_light :PointLight2D = $CampFireLight
@onready var on_camera :VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var interactible :Interactible = $Interactible
@onready var bgm_camp_fire :AudioStreamPlayer2D = $BgmCampFire
@onready var sfx_crackle :AudioStreamPlayer2D = $SfxCrackle

func _ready()->void:
	is_lit = true
	signaler()
	fire_light.energy = DayNighton.time_dictionary[DayNighton.current_time]["camp_fire_energy"]

func signaler()->void:
	Libraryton.player_reference.connect(func(ref): player = ref)
	observer_null.connect(func(func_name): Observerton.match_null(self, func_name))

func light_fire()->void:
	if is_lit: is_lit = false
	else:      is_lit = true


func lerp_light(new_time :int)->void:
	if tween and tween.is_valid(): tween.kill()
	tween = create_tween()
	tween.tween_property(fire_light, 'energy',
		max_light - ((time_dictionary[new_time]['modulate']/255.0) * (max_light - min_light)),
		time_dictionary[new_time]['modulate_duration'])


#region DEBUG
@onready var debug_icon :String = "[img]res://resources/campFire/campfire.png[/img]"
#endregion
