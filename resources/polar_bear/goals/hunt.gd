extends Node #hunt.gd
signal start_hunt(name)
func enter()->void:
	start_hunt.emit("Chase")
