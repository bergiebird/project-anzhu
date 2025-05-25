extends AnimalAnimations
class_name BearAnimations

func stunned_anim():
	var is_colored :bool = false
	while (animation == "Stunned"):
		is_colored = !is_colored
		if is_colored:
			parent.modulate = Swatchton.RED_TOMATO
		else:
			parent.modulate = Swatchton.BASIC_WHITE
		await get_tree().create_timer(.32).timeout
	parent.modulate = Swatchton.BASIC_WHITE

func change_actions(new_action :String):
	match new_action:
		"Stunned":
			update_animations("Stunned")
			stunned_anim()
		"Wander":
			update_animations("Wander")
		"Sit":
			update_animations("Sit")
		"Idle":
			update_animations("Idle")
		"Chase":
			update_animations("Chase")


func _on_animation_changed() -> void:
	if debug_self:
		print(animation)
