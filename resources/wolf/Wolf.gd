@icon("res://resources/wolf/wolf.png")
class_name Wolf extends AnzhuAnimal #Wolf.gd

func animal_ready()->void:
	add_to_group("wolf")
