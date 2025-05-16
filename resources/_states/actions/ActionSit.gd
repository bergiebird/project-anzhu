class_name ActionSit extends ActionState

func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalActions.Sit

func ___enter():
	grandparent.publisher_one.emit("update_animations", "Sit")
