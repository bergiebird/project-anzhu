extends AnzhuBeing
class_name AnzhuAnimal

func set_stun_state(bol :bool):
	is_sliding = bol

func __setup_basics():
	add_to_group('animal')
