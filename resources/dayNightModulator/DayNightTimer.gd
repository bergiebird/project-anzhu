extends Timer #DayNightTimer.gd

@onready var day_night_system :DayNighton= DayNighton

func _on_timeout()->void:
	day_night_system.progress_time()
