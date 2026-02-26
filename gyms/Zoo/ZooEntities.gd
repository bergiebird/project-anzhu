extends CanvasGroup #ZooEntities.gd

func get_all_beings()->Array[AnzhuBeing]:
	var beings_container: Array[AnzhuBeing] = []
	for child in get_children():
		if child is AnzhuBeing:
			beings_container.append(child)
	print(beings_container)
	return beings_container
