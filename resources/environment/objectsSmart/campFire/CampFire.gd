@icon("res://resources/environment/objectsSmart/campFire/campfire.png")
class_name CampFire extends StaticBody2D #CampFire.gd
@export var min_light :float = 0.1
@export var max_light :float = 1.0
@export var is_lit :bool = true
var tween :Tween
var time_dictionary :Dictionary
@onready var player :AnzhuHuman = %Player
@onready var fire_anim :AnimatedSprite2D = $CampFireAnimation
@onready var fire_light :PointLight2D = $CampFireLight
@onready var on_camera :VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready()->void:
	signal_connector()

func signal_connector()->void:
	DayNighton.time_progressed.connect(lerp_light)
	DayNighton.time_dictionary_delivery.connect(dictionary_inbox)
	on_camera.screen_entered.connect(_on_screen_entered)
	on_camera.screen_exited.connect(_on_screen_exited)

func dictionary_inbox(incoming_delivery :Dictionary)->void:
	time_dictionary = incoming_delivery

###
## FUNCTIONS
###

func _on_screen_exited()->void:
	player.affect_nightlight(true)

func _on_screen_entered()->void:
	player.affect_nightlight(false)

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
	tween.tween_property(
		fire_light,
		'energy',
		max_light - ((time_dictionary[new_time]['modulate']/255.0) * (max_light - min_light)),
		time_dictionary[new_time]['modulate_duration'])


###
##	DEBUG
###

@onready var debug_icon :String = "[img]res://resources/campFire/campfire.png[/img]"
