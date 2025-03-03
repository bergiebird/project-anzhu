extends VisibleOnScreenNotifier2D #eyesight.gd

var has_grievance :bool = false
var is_spotted :bool = false

signal sight_update(string_name :String)

func _on_screen_exited() -> void:
	if has_grievance:
		sight_update.emit("OutOfSight")
	is_spotted = false

func _on_screen_entered() -> void:
	if has_grievance:
		sight_update.emit("Spotted")
	is_spotted = true

func _just_shot(_action_name: String) -> void:
	if has_grievance:
		return
	has_grievance = true
