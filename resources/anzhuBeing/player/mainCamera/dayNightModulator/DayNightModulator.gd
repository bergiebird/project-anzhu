@icon("res://resources/anzhuBeing/player/mainCamera/dayNightModulator/icon_area_meteo.png")
extends CanvasModulate
class_name DayNightModulator

const TOO_DARK_THRESHOLD :float = 0.025

@export var starting_TimeOfDay :DayNighton.TimeOfDay = DayNighton.TimeOfDay.LATE_NIGHT

var init_time_lerp :Array = []
var modulate_dictionary :Dictionary
var first_time :bool = true
var is_nightlight_on :bool

@onready var time_to_pass :int = int(DayNighton.WORLD_TIMER_WAIT_TIME)
@onready var lerp_times :Array[float] = [1, 1, 1, 1,1, 1, 1, 1]

func _ready():
	prepare_lerp_time()
	modulate_dictionary = DayNighton.initialize(self)
	DayNighton.time_progressed.connect(sun_change)
	DayNighton.progress_time(starting_TimeOfDay)

func sun_change(new_time :int):
	_debug_sun_change(new_time)
	var rgb :float = modulate_dictionary[new_time]['modulate']/255.0
	if first_time:
		first_time = false
		Builderton.tweener_deferred(self,'color',Color(rgb,rgb,rgb),0)
	else:
		Builderton.tweener_deferred(self,'color', Color(rgb,rgb,rgb), 0)

func prepare_lerp_time():
	_debug_resize(init_time_lerp.resize(DayNighton.TimeOfDay.size()))
	for index :int in range(lerp_times.size()):
		if lerp_times[index] < 1:
			init_time_lerp[index] = 1
		else:
			init_time_lerp[index] = int(time_to_pass/lerp_times[index])

func _process(_delta :float):
	if color.r <= TOO_DARK_THRESHOLD:
		if not is_nightlight_on:
			DayNighton.time_progressed_nightlight.emit(true)
			is_nightlight_on = true
	elif color.r > TOO_DARK_THRESHOLD:
		if is_nightlight_on:
			is_nightlight_on = false
			DayNighton.time_progressed_nightlight.emit(false)


#region #===========================================================================# DEBUG
@export_group('DEBUG')
@export var debug :bool = true

func _debug_sun_change(new_time :int):
	if debug:
		print_rich("[color=#FFD700]⏰ Time has changed:[/color] [color=#87CEEB]" + modulate_dictionary[new_time]['name'] + "[/color]")

func _debug_resize(resize_return :int):
	if debug:
		Debuggerton.dprint(str(resize_return))
#endregion #========================================================================# DEBUG
