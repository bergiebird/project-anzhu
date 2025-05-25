@icon("res://resources/environment/objectsSmart/campFire/campfire.png")
class_name CampFire extends StaticBody2D

signal publisher_null(String)
signal publisher_one(String, Variant)
@export var min_light :float = 0.1
@export var max_light :float = 1.0
@export var is_lit :bool

var time_dictionary :Dictionary

@onready var fire_anim :AnimatedSprite2D = $Fire
@onready var fire_light :PointLight2D = $Light
@onready var bgm_camp_fire :AudioStreamPlayer2D = $BgmCampFire
@onready var sfx_crackle :AudioStreamPlayer2D = $SfxCrackle
@onready var heal_zone :CampFireHeal = $Heal

func _ready():
	is_lit = false
	publisher_null.connect(func(func_name): Observerton.subscribe_null(self, func_name))
	fire_light.energy = DayNighton.time_dictionary[DayNighton.current_time]["camp_fire_energy"]

func interacted(): # Light/Unlight Fire
	is_lit = !is_lit
	fire_light.visible = is_lit
	if is_lit:
		sfx_crackle.play()
		bgm_camp_fire.play()
	else:
		bgm_camp_fire.stop()
		sfx_crackle.stop()
	fire_anim.visible = is_lit
	heal_zone.heal()




#region    #==============================================================================# DEBUG
@onready var debug_icon :String = "[img]res://resources/campFire/campfire.png[/img]"
#endregion #==============================================================================# DEBUG



#func lerp_light(new_time :int):
	#Builderton.tweener_deferred(fire_light, 'energy', max_light - ((time_dictionary[new_time]['modulate']/255.0) * (max_light - min_light)), time_dictionary[new_time]['modulate_duration'])
