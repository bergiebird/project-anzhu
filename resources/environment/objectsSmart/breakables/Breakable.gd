@icon("res://resources/environment/objectsSmart/breakables/breakable.png")
extends Area2D
class_name Breakable

@onready var parent :StaticBody2D = get_parent()

func _ready():
	body_entered.connect(_body_entered)

func _body_entered(body :Node2D):
	if parent.has_method("on_break"):
						parent.on_break(body)
