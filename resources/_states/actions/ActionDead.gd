extends ActionState #ActionDead.gd
var sfx_death_howl :AudioStreamPlayer2D

func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalActions.Dead

func ___grandparent_acquired():
	grandparent.publisher_null.connect(func(func_name): Observerton.subscribe_null(self, func_name))

func ___enter()->void:
	grandparent.publisher_null.emit("has_died")
	if has_node("SfxDeathHowl"):
		sfx_death_howl = get_node("SfxDeathHowl")
		sfx_death_howl.play()
		await get_tree().create_timer(sfx_death_howl.get_stream().get_length() + 0.1).timeout
	grandparent.publisher_null.emit("end_of_life")
