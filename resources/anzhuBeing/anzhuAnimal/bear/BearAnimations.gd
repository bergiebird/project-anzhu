class_name BearAnimations extends AnimalAnimations


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
