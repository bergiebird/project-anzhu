@icon("res://resources/environment/objectsSmart/breakables/CrackedWall/cracked_wall.png")
extends StaticBody2D
class_name CrackedWall

func on_break(_body: Node2D):
	print("====BROKEN")
