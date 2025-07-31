@icon("res://resources/anzhuBeing/anzhuAnimal/walrus/walrus.png")


class_name Walrus
extends AnzhuAnimal

func early_ready_for_debug():
	if debug_self:
		debug_icon = "[img]res://resources/anzhuBeing/anzhuAnimal/walrus/walrus.png[/img]"
		print_rich(debug_icon)
