extends Timer

@onready var day_night_system :DayNighton= DayNighton

func _on_timeout()->void:
	if day_night_system:
		day_night_system.progress_time()
	else: push_error('DayNighton not found')
