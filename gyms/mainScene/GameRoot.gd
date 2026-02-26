@icon("res://gyms/mainScene/game.png")

class_name GameRoot
extends Node2D



enum InteraticbleType {
	BOOK_1,
	BOOK_2,
	SHELF,
	PRINTER,
}
@export var which_type: InteraticbleType


func _interacted():
	match which_type:
		InteraticbleType.BOOK_1:
			pass
		InteraticbleType.SHELF:
			pass
		InteraticbleType.PRINTER:
			pass
