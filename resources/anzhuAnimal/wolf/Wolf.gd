@icon("res://resources/anzhuAnimal/wolf/wolf.png")
class_name Wolf extends AnzhuAnimal #Wolf.gd
@onready var animal_icon = "[img]res://resources/wolf/wolf.png[/img]"

func early_ready_for_debug()->void:
	if debug_self:
		debug_icon = "[img]res://resources/wolf/wolf.png[/img]"
		print_rich(debug_icon)

func animal_ready()->void:
	add_to_group("wolf")
