extends ActionState #ActionDead.gd
var sfx_death_howl :AudioStreamPlayer2D

func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalActions.Dead
