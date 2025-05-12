@icon("res://resources/anzhuBeing/anzhuAnimal/bear/bear.png")
class_name Bear extends AnzhuAnimal #Bear.gd


func ___ready()->void:
	add_to_group("Bear")
	current_speed = move_speed


func ___was_just_struck(_damage :int, _weapon :String, _who:AnzhuBeing)->void:
	observer_null.emit("hit_over")
	is_sliding = false
	change_actions("Chase")
