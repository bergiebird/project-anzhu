extends AnimalAnimations
class_name WalrusAnimations


func change_actions(new_action: String):
	match new_action:
		"Idle":
			update_animations("Idle")
		"Stunned":
			update_animations("Stunned")
		"Wander":
			update_animations("Wander")
		"Roll":
			update_animations("Roll")
