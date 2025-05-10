@icon("res://resources/anzhuBeing/player/mainCamera/dayNightModulator/icon_area_meteo.png")
class_name DayNightModulator extends CanvasModulate #DayNightModulator.gd
const TOO_DARK_THRESHOLD :float = 0.025
@export_enum("DAWN", "MORNING", "NOON", "AFTERNOON", "DUSK", "NIGHT", "MIDNIGHT", "LATE_NIGHT") var starting_TimeOfDay :int = DayNighton.TimeOfDay.LATE_NIGHT
@export var dawn_lerp_time :float = 1
@export var morning_lerp_time :float = 1
@export var noon_lerp_time :float = 1
@export var afternoon_lerp_time :float = 1
@export var dusk_lerp_time :float = 1
@export var night_lerp_time :float = 1
@export var midnight_lerp_time :float = 1
@export var late_night_lerp_time :float = 1
var init_time_lerp :Array = []
var modulate_dictionary :Dictionary
var tween :Tween
var first_time :bool = true
var is_nightlight_on :bool
@onready var time_to_pass :int = int(DayNighton.WORLD_TIMER_WAIT_TIME)
@onready var lerp_times :Array[float] = [
	dawn_lerp_time, morning_lerp_time, noon_lerp_time, afternoon_lerp_time,
	dusk_lerp_time, night_lerp_time, midnight_lerp_time, late_night_lerp_time]

func _ready( )->void:
	init_assertions()
	prepare_lerp_time()
	modulate_dictionary = DayNighton.initialize(self)
	DayNighton.time_progressed.connect(sun_change)
	DayNighton.progress_time(starting_TimeOfDay)

func sun_change(new_time :int)->void:
	_debug_sun_change(new_time)
	var rgb :float = modulate_dictionary[new_time]['modulate']/255.0
	if first_time:
		first_time = false
		Builderton.tweener_deferred(self,'color',Color(rgb,rgb,rgb),0)
	else:
		Builderton.tweener_deferred(self,'color', Color(rgb,rgb,rgb), 0)

func prepare_lerp_time( )->void:
	_debug_resize(init_time_lerp.resize(DayNighton.TimeOfDay.size()))
	for index :int in range(lerp_times.size()):
		if lerp_times[index] < 1:
			init_time_lerp[index] = 1
		else:
			init_time_lerp[index] = int(time_to_pass/lerp_times[index])

func _process(_delta :float)->void:
	if color.r <= TOO_DARK_THRESHOLD:
		if not is_nightlight_on:
			DayNighton.time_progressed_nightlight.emit(true)
			is_nightlight_on = true
	elif color.r > TOO_DARK_THRESHOLD:
		if is_nightlight_on:
			is_nightlight_on = false
			DayNighton.time_progressed_nightlight.emit(false)


###
## DEBUG
###
@export_group('DEBUG')
@export var debug :bool = true

func _debug_sun_change(new_time :int)->void:
	if debug:
		print_rich("[color=#FFD700]⏰ Time has changed:[/color] [color=#87CEEB]" + modulate_dictionary[new_time]['name'] + "[/color]")

func _debug_resize(resize_return :int)->void:
	if debug:
		Debuggerton.dprint(str(resize_return))

func init_assertions()->void:
	assert(time_to_pass, "time_to_pass not properly instantiated in DayNightModulator.gd")
	assert(starting_TimeOfDay, "starting_TimeOfDay not properly instantiated in DayNightModulator.gd")
	assert(dawn_lerp_time, "dawn_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(morning_lerp_time, "morning_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(noon_lerp_time, "noon_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(afternoon_lerp_time, "afternoon_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(dusk_lerp_time, "dusk_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(night_lerp_time, "night_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(midnight_lerp_time, "midnight_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(late_night_lerp_time, "late_night_lerp_time not properly instantiated in DayNightModulator.gd")
