class_name ActionIdle extends ActionState

func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalActions.Idle


func ___enter():
	grandparent.publisher_one.emit("update_animations", "Idle")
