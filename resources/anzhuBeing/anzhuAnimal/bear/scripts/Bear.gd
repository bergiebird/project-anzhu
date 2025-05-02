@icon("res://resources/anzhuBeing/anzhuAnimal/bear/bear.png")
class_name Bear extends AnzhuAnimal #Bear.gd


func animal_ready()->void:
	add_to_group("Bear")
	current_speed = move_speed

func animal_strike()->void:
	pass

func character_was_hit_over()->void:
	hit_over.emit()
	is_sliding = false
	change_actions("Chase")


###
## DEBUG
###
