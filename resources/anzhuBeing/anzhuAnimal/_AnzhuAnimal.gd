extends AnzhuBeing
class_name AnzhuAnimal

func __was_just_struck(_attack :Dictionary)->void:
	is_sliding = true

func __setup_basics():
	add_to_group('animal')
