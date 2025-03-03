@icon("res://warehouse/_icons/control/icon_transition.png")
extends CollisionShape2D #ui_stats.gd

##Must be either 1,2,4, or 8
@export var damage_taken_per_hit :int = 1
@export var only_needs_collider :bool = false
var stats_dictionary :Dictionary = {}

func _ready()->void:
	for child in get_children():
		if child is ColorRect:
			if only_needs_collider:
				child.queue_free()
			else:
				stats_dictionary[child.name] = child


func increment_values(name_of_stat :String)->void:
	stats_dictionary.get("Ui_" + name_of_stat).increment(damage_taken_per_hit)
