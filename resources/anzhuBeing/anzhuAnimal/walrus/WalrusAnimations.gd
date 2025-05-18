class_name WalrusAnimations extends AnimalAnimations


func change_actions(new_action :String):
	match new_action:
		"Stunned":
			update_animations("Stunned")
			stunned_anim()
		"Wander":
			update_animations("Wander")
		"Idle":
			update_animations("Idle")
		"Roll":
			update_animations("Roll")
