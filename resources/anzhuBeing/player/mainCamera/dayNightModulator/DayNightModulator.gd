@icon("res://resources/anzhuBeing/player/mainCamera/dayNightModulator/icon_area_meteo.png")
extends CanvasModulate
class_name DayNightModulator

@export_enum("Dawn", "Morning", "Noon", "Afternoon", "Dusk",
"Night", "Midnight", "Late Night") var START_TIME :String = "Dawn"
var current_time :String
var night_lights_on :bool
var init_time_lerp :Array = []
var first_time :bool = true
var is_nightlight_on :bool
var time_dictionary :Dictionary
@onready var world_timer :Timer = $WorldTimer

func _ready():
	time_dictionary =L.World.TIME
	world_timer.timeout.connect(progress_time)
	current_time = START_TIME
	Signalton.time_dictionary_delivery.emit(time_dictionary)
	progress_time(current_time)

func _process(_delta :float):
	if color.r <=L.World.TOO_DARK_THRESHOLD:
		if not is_nightlight_on:
			Signalton.new_hour_nightlight.emit(true)
			is_nightlight_on = true
	elif color.r >L.World.TOO_DARK_THRESHOLD:
		if is_nightlight_on:
			is_nightlight_on = false
			Signalton.new_hour_nightlight.emit(false)

func progress_time(_incoming_time :String=current_time):
	current_time = time_dictionary[current_time]["next_time"]
	var new_hour :Dictionary = time_dictionary[current_time]
	var modulation :float = new_hour['modulate']
	Builderton.tweener_deferred(self,'color', Color(modulation,modulation,modulation), 5)
	Signalton.new_hour.emit()
	Signalton.new_hour_name.emit(current_time)
	Signalton.new_hour_nightlight.emit(new_hour['night_lights_on'])
	Signalton.new_hour_campfire.emit(new_hour['camp_fire_energy'])
	_debug_sun_change()


#region    #=============================================# DEBUG
@export_group('DEBUG')
@export var debug :bool = true

func _debug_sun_change():
	if debug:
		print_rich("[color=#FFD700]⏰:[/color] [color=#87CEEB]" + current_time + "[/color]")

func _debug_resize(resize_return :int):
	if debug:
		Debuggerton.dprint(str(resize_return))
#endregion #========================================================================# DEBUG
