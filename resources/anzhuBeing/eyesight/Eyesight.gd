class_name Eyesight extends VisibleOnScreenNotifier2D

@onready var parent = get_parent()

signal sight_update(string_name :String)

###
## DEBUG
###
@export_category('DEBUG')
@export var debug_eyesight :bool = false
func debug()->void:
	debug_eyesight = true
