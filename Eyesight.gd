extends Area2D
class_name Eyesight

var is_spotted :bool = false:
	set(value): if value != is_spotted:
		is_spotted = value
		if has_grievance:
			if is_spotted:  parent.publish_event.emit("player_spotted")
			else:           parent.publish_event.emit("player_out_of_sight")

var has_grievance :bool = false:
	set(value): if value != has_grievance:
		has_grievance = value
		if is_spotted:
			parent.publish_event.emit('change_goals', 'Hunt')

@onready var parent :AnzhuBeing = get_parent()



func _ready() -> void:
	__ready()
	__signaler()


func __ready(): pass
func __signaler(): pass
