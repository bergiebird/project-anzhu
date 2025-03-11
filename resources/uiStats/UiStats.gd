@icon("res://warehouse/_icons/control/icon_transition.png")
extends CollisionShape2D #UiStats.gd

signal is_dead(dead_name :String)

@export var only_needs_collider :bool = false
@export var damage_value :int = 1
var stats_dictionary :Dictionary = {}
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary

func _ready()->void:
	for child in get_children():
		if child is ColorRect:
			if only_needs_collider:
				child.queue_free()
			else:
				stats_dictionary[child.name] = child

func increment_values(name_of_stat :String = 'Hit')->void:
	stats_dictionary.get("Ui_" + name_of_stat).increment(damage_value)

func character_has_died()->void:
	is_dead.emit("Dead")

func disappear_on_jump()->void:
	visible = false

func appear_on_land()->void:
	visible = true
