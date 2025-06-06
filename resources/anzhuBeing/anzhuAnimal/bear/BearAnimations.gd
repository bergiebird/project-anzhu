extends AnimalAnimations
class_name BearAnimations


func update_animation_stunned():
	update_animations("Stunned")
	while (animation == "Stunned"):
		match parent.modulate:
			L.BasicPalette.BASIC_WHITE:
				parent.modulate = L.Palette.RED_TOMATO
			_:
				parent.modulate =L.BasicPalette.BASIC_WHITE
		await get_tree().create_timer(.30).timeout
	parent.modulate =L.BasicPalette.BASIC_WHITE

func change_actions(new_action :String):
	if new_action is String:
		match new_action:
			"Stunned": update_animation_stunned()
			"Wander":  update_animations("Wander")
			"Sit":     update_animations("Sit")
			"Idle":    update_animations("Idle")
			"Chase":   update_animations("Chase")




#region    #===================================================# DEBUG
func _on_animation_changed() -> void:
	if debug_self:
		print(animation)
#endregion #===================================================# DEBUG
