extends ColorRect #hurt.gd


func _on_shot() -> void:
	size.y += 1
	position.y -= 1

	if size.y < 8:
		return
	if position.y > 0:
		return

	print('dead')
	get_parent().get_parent().queue_free()
