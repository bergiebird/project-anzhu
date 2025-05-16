class_name ActionHit extends ActionState

const DEFAULT_COLOR :Color = Swatchton.BASIC_WHITE
const RED_COLOR :Color = Swatchton.RED_TOMATO

func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalActions.Hit

func ___enter()->void:
	grandparent.change_goals("Hunt")
	was_just_hit()



func ___exit()->void:
	parent.self_modulate = DEFAULT_COLOR
	parent.modulate = DEFAULT_COLOR
	grandparent.publisher_one.emit("set_hurtbox_monitoring", true)
	if grandparent.has_method("uninjur"):
		grandparent.uninjur()
