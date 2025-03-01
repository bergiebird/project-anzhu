extends ColorRect #hurt.gd

signal polar_bear_dead()

func _on_shot() -> void:
	size.y += 1
	position.y -= 1
	if size.y < 8:     return
	if position.y > 0: return
	print('dead')
	polar_bear_dead.emit()
