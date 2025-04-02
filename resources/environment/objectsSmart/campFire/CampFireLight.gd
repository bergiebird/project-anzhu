extends PointLight2D #CampFireLight.gd

@onready var parent :StaticBody2D
@onready var fire_anim :AnimatedSprite2D = %CampFireAnimation
@onready var day_night :DayNighton = DayNighton
var has_parent :bool = false
var time_dictionary :Dictionary
var tween :Tween
var is_lit :bool

func _ready()->void:
	day_night.time_progressed.connect(lerp_light)
	day_night.time_dictionary_delivery.connect(dictionary_inbox)
	set_flame()

func lerp_light(new_time :int)->void:
	if not is_lit:
		visible = false
		fire_anim.play("unlit")
	else:
		visible = true
		fire_anim.play('lit')
	var target_energy = parent.maximum_light - (
(time_dictionary[new_time]['modulate']/255.0) * (parent.maximum_light - parent.minimum_light))
	if tween and tween.is_valid(): tween.kill()
	tween = create_tween()
	tween.tween_property(self, 'energy', target_energy, time_dictionary[new_time]['modulate_duration'])

func dictionary_inbox(incoming_delivery :Dictionary)->void:
	time_dictionary = incoming_delivery

func set_flame()->void:
	parent = get_parent()
	is_lit = parent.is_lit
	has_parent = true
