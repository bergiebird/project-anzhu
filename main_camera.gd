class_name MainCamera extends Camera2D #MainCamera.gd

@onready var snow_fall :Node = $SnowFall

func _ready()->void:
	Signalton.weather_changed.connect(func():
		print('weather_changed_recieved')
		snow_fall.change_weather_randomly())
