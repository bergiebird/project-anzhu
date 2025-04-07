@icon("res://resources/anzhuAnimal/bear/bear.png") #Polar Bear
class_name Bear extends AnzhuAnimal #Bear.gd
@onready var animal_icon = "[img]res://resources/bear/bear.png[/img]"

func animal_ready()->void:
	add_to_group("bear")
	current_speed = move_speed

func _physics_process(delta :float)->void:
	move_and_slide()

func animal_strike()->void:
	pass

func character_hit_over()->void:
	change_actions("Chase")
