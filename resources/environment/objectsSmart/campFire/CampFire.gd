@icon("res://resources/environment/objectsSmart/campFire/campfire.png")

class_name CampFire
extends StaticBody2D

@export var min_light: float = 0.1
@export var max_light: float = 1.0
@export var is_lit: bool

var time_dictionary: Dictionary

@onready var fire_anim: AnimatedSprite2D = $Fire
@onready var fire_light: PointLight2D = $Light
@onready var bgm_camp_fire: AudioStreamPlayer2D = $BgmCampFire
@onready var sfx_crackle: AudioStreamPlayer2D = $SfxCrackle


func _ready():
	fire_light.visible = is_lit
	_interacted()
	for child:Node in get_children():
		if child is Interactible:
			child.interacted.connect(_interacted)
	Sgnl.new_hour_campfire.connect(lerp_light)


func lerp_light(new_energy: float):
	Buildton.tweener_deferred(fire_light, 'energy', new_energy, 10)


func _interacted(): ## Light/Unlight Fire
	if fire_light.visible:
		fire_light.visible = false
		fire_anim.visible = false
		bgm_camp_fire.stop()
		sfx_crackle.stop()
	else:
		fire_light.visible = true
		fire_anim.visible = true
		sfx_crackle.play()
		bgm_camp_fire.play()


#region    #==============================================================================# DEBUG
@onready var debug_icon :String = "[img]res://resources/campFire/campfire.png[/img]"
#endregion
