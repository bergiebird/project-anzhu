@icon("res://warehouse/_icons/node_2D/icon_bag.png")
extends Area2D #Corpse.gd

var parent
var animal_type
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		parent = node_dictionary['parent']
		animal_type = parent.AnimalType

func _ready() -> void:
	connect('body_entered', _on_body_entered)


func allow_pickup()->void:
	print('monitoring')
	monitorable = true
	monitoring = true


func _on_body_entered(body: Node2D) -> void:
	print('+1')
	queue_free()
