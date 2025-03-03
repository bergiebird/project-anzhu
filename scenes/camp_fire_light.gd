extends PointLight2D #camp_fire_light.gd

@onready var parent :Node2D = get_parent()
var time_dictionary :Dictionary
var tween :Tween

func _ready()->void:
	DayNighton.time_progressed.connect(lerp_light)
	DayNighton.time_dictionary_delivery.connect(dictionary_inbox)

func lerp_light(new_time :int)->void:
	# Using the dictionary, pages to the new_time and determines its new set modulate. Then clamps it within the max and min. It inverses the result.
	var target_energy = parent.maximum_light - ((time_dictionary[new_time]['modulate']/255.0) * (parent.maximum_light - parent.minimum_light))
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, 'energy', target_energy, time_dictionary[new_time]['modulate_duration'])

func dictionary_inbox(incoming_delivery :Dictionary)->void:
	time_dictionary = incoming_delivery
