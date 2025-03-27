@icon("res://resources/anzhuAnimal/bear/bear.png") #Polar Bear
class_name Bear extends AnzhuAnimal #Bear.gd
@onready var animal_icon = "[img]res://resources/bear/bear.png[/img]"


func early_ready_for_debug()->void:
	if debug_self:
		debug_icon = "[img]res://resources/bear/bear.png[/img]"
		print_rich(debug_icon)

func animal_ready()->void:
	add_to_group("bear")
	current_speed = move_speed

func hit_over()->void: # Should Invoke Revenge
	change_actions("Chase")

func _physics_process(delta :float)->void:
	move_and_slide()

func stop_in_tracks(unused_string)->void:
	velocity = Vector2.ZERO
