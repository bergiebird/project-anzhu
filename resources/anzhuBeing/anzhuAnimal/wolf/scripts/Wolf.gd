@icon("res://resources/anzhuAnimal/wolf/wolf.png")
extends AnzhuAnimal
class_name Wolf

func early_ready_for_debug()->void:
	if debug_self:
		debug_icon = "[img]res://resources/wolf/wolf.png[/img]"
		print_rich(debug_icon)

func animal_ready()->void:
	add_to_group("wolf")
