class_name Actions extends Node #actions.gd

@onready var movement :Node = $Movement

func allow_movement()->void:
	movement.move()
