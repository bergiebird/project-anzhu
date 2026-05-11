
extends AnimalAnimations
class_name BearAnimations


func update_animation_stunned() -> void:
	update_animations("Stunned")
	while (animation == "Stunned"):
		match parent.modulate:
			Lib.BasicPalette.BASIC_WHITE:
				parent.modulate = Lib.Palette.RED_TOMATO
			_:
				parent.modulate =Lib.BasicPalette.BASIC_WHITE
		await get_tree().create_timer(.30).timeout
	parent.modulate =Lib.BasicPalette.BASIC_WHITE


func change_actions(new_action: String) -> void:
	if new_action is String:
		match new_action:
			"Stunned":
				update_animation_stunned()
			"Wander":
				update_animations("Wander")
			"Sit":
				update_animations("Sit")
			"Idle":
				update_animations("Idle")
			"Chase":
				update_animations("Chase")
