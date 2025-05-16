class_name BearEyeSight extends Eyesight

var has_grievance :bool = false
var is_spotted :bool = false

func __on_screen_exited() -> void:
	if has_grievance:
		parent.observer_null.emit("player_out_of_sight")
	is_spotted = false

func __on_screen_entered() -> void:
	if has_grievance:
		parent.observer_null.emit("player_spotted")
	is_spotted = true

func was_struck()->void:
	if not has_grievance:
		has_grievance = true

func loud_noise()->void:
	if is_spotted:
		parent.publisher_one.emit('change_goals', 'Hunt')
