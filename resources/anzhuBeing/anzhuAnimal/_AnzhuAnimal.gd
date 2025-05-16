class_name AnzhuAnimal extends AnzhuBeing

func __ready()->void:
	add_to_group('animal')

func __was_just_struck(_damage :int, _weapon :String, _who :AnzhuBeing)->void:
	is_sliding = true
