@icon("res://resources/environment/objectsSmart/campFire/campfire.png")
class_name CampFire extends StaticBody2D #CampFire.gd
@export var min_light :float = 0.1
@export var max_light :float = 1.0
@export var is_lit :bool = true
var tween :Tween
var time_dictionary :Dictionary
@export var player :AnzhuHuman :
	set(value): ## If player exists, we enable this functionality.
		if value != player:
			player = value
			##HACK: Commented out to get around error: Invalid access to property or key 'screen_entered' on a base object of type 'Nil'.
			#Debuggerton.signal_checker([
				#on_camera.screen_entered.connect(func(): player.affect_nightlight.emit(false)),
				#on_camera.screen_exited.connect(func(): player.affect_nightlight.emit(true))
			#])
@onready var fire_anim :AnimatedSprite2D = $CampFireAnimation
@onready var fire_light :PointLight2D = $CampFireLight
@onready var on_camera :VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready()->void:
	signaler()

func signaler()->void:
	Debuggerton.signal_checker([
		DayNighton.time_progressed.connect(lerp_light),
		DayNighton.time_dictionary_delivery.connect(func(delivery :Dictionary): time_dictionary = delivery),
		Libraryton.player_reference.connect(func(ref): player = ref)
	])

###
## FUNCTIONS
###

func lerp_light(new_time :int)->void:
	if not is_lit:
		fire_light.visible = false
		fire_anim.play("unlit")
	else:
		fire_light.visible = true
		fire_anim.play('lit')
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(fire_light, 'energy',
		max_light - ((time_dictionary[new_time]['modulate']/255.0) * (max_light - min_light)),
		time_dictionary[new_time]['modulate_duration'])


###
##	DEBUG
###
@onready var debug_icon :String = "[img]res://resources/campFire/campfire.png[/img]"
