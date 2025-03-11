@icon("res://resources/bear/bear.png")
class_name Bear extends AnzhuAnimal #Bear.gd

var hurt_box :Area2D

func animal_ready()->void:
	add_to_group("bear")
	hurt_box = scenes_nodes['HurtBox']
	current_speed = move_speed

func hit_over()->void:
	change_actions("Chase")

func animal_end_of_life()->void:
	has_died.emit(audio.get_is_playing("Hunt"))

func uninjur()->void:
	is_injured = false

func _physics_process(delta: float) -> void:
	hurt_box.update_and_match_attacking_direction(abs(get_real_velocity()))
	move_and_slide()
