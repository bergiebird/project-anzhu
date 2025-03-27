@icon("res://warehouse/icons/node/icon_time.png")
extends Timer #WorldTimer.gd

@onready var day_night_system :DayNighton= DayNighton

func _on_timeout()->void:
	day_night_system.progress_time()
