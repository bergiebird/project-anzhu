@icon("res://resources/campFire/campfire.png")
extends StaticBody2D #CampFire.gd

@export var minimum_light :float = 0.1
@export var maximum_light :float = 1.0
@export var is_lit :bool = true
@onready var player :AnzhuHuman = %Player



func _on_screen_exited()->void:
	player.affect_nightlight(true)

func _on_screen_entered()->void:
	player.affect_nightlight(false)
