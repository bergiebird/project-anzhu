@icon("res://resources/anzhuAnimal/walrus/walrus.png")
class_name Walrus extends AnzhuAnimal #Walrus.gd
@onready var animal_icon = "[img]res://resources/walrus/walrus.png[/img]"

func early_ready_for_debug()->void:
	if debug_self:
		debug_icon = "[img]res://resources/walrus/walrus.png[/img]"
		print_rich(debug_icon)


func animal_ready()->void:
	add_to_group("walrus")
