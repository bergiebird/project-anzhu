extends ColorRect #hurt.gd

func increment(incoming_value :int) -> void:
	size.y += incoming_value
	position.y -= incoming_value
	if size.y < 8:
		return
	if position.y > 0:
		return
	print('dead')
