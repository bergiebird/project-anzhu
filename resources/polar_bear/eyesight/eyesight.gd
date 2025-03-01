extends VisibleOnScreenNotifier2D #eyesight.gd

@onready var out_of_sight_timer :Timer = $OutOfSightTimer
var has_grievance :bool = false

signal enraged()
signal lost_sight()

func _on_screen_exited() -> void:
	if has_grievance:
		lost_sight.emit()
		out_of_sight_timer.start()

func _on_hit_polar_bear_shot() -> void:
	if has_grievance:
		return
	has_grievance = true

func _on_screen_entered() -> void:
	if has_grievance:
		enraged.emit()
