@icon("res://resources/anzhuAnimal/fox/fox.png")
class_name Hare extends AnzhuAnimal

func animal_ready()->void:
	add_to_group("Hare")






###
## DEBUG
###
func early_ready_for_debug()->void:
	if debug_self:
		debug_icon = "[img]res://resources/fox/fox.png[/img]"
		print_rich(debug_icon)
