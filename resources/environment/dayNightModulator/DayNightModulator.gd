@icon("res://warehouse/_icons/node_2D/icon_area_meteo.png")
extends CanvasModulate #DayNightModulator.gd
@onready var world_timer :Timer = $WorldTimer
@onready var time_to_pass :int = int(world_timer.wait_time)
@export_enum("DAWN", "MORNING", "NOON", "AFTERNOON", "DUSK", "NIGHT", "MIDNIGHT", "LATE_NIGHT") var time_right_before_start :int = DayNighton.TimeOfDay.LATE_NIGHT
@export var dawn_lerp_time :float = 1
@export var morning_lerp_time :float = 1
@export var noon_lerp_time :float = 1
@export var afternoon_lerp_time :float = 1
@export var dusk_lerp_time :float = 1
@export var night_lerp_time :float = 1
@export var midnight_lerp_time :float = 1
@export var late_night_lerp_time :float = 1
var init_time_lerp :Array = []
var modulates_time_of_day_dictionary :Dictionary
var tween :Tween
var lerp_times :Array
var first_time :bool = true
var is_on :bool

func _ready()->void:
	init_assertions()
	world_timer.timeout.connect(func():DayNighton.progress_time())
	lerp_times = [dawn_lerp_time, morning_lerp_time, noon_lerp_time, afternoon_lerp_time, dusk_lerp_time, night_lerp_time, midnight_lerp_time, late_night_lerp_time]
	prepare_lerp_time()
	modulates_time_of_day_dictionary = DayNighton.initialize(self)
	DayNighton.time_progressed.connect(sun_change)
	DayNighton.progress_time(time_right_before_start)

func sun_change(new_time)->void:
	print_rich("[color=#FFD700]⏰ Time has changed:[/color] [color=#87CEEB]" + modulates_time_of_day_dictionary[new_time]['name'] + "[/color]")
	var rgb_calculated :float = modulates_time_of_day_dictionary[new_time]['modulate']/255.0
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	if first_time:
		first_time = false
		tween.tween_property(self,'color',Color(rgb_calculated,rgb_calculated,rgb_calculated),0)
	else:
		tween.tween_property(self,'color', Color(rgb_calculated,rgb_calculated,rgb_calculated),modulates_time_of_day_dictionary[new_time]['modulate_duration'])

func prepare_lerp_time()->void:
	init_time_lerp.resize(DayNighton.TimeOfDay.size())
	for index in range(lerp_times.size()):
		if lerp_times[index] < 1:
			init_time_lerp[index] = 1
		else:
			init_time_lerp[index] = int(time_to_pass/lerp_times[index])

func _process(delta: float) -> void:
	if color.r <= .025:
		if not is_on:
			DayNighton.turn_on_night_lights.emit(true)
			is_on = true
	elif color.r > .025:
		if is_on:
			is_on = false
			DayNighton.turn_on_night_lights.emit(false)


###
## DEBUG
###
func init_assertions()->void:
	assert(world_timer, "world_timer not properly instantiated in DayNightModulator.gd")
	assert(time_to_pass, "time_to_pass not properly instantiated in DayNightModulator.gd")
	assert(time_right_before_start, "time_right_before_start not properly instantiated in DayNightModulator.gd")
	assert(dawn_lerp_time, "dawn_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(morning_lerp_time, "morning_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(noon_lerp_time, "noon_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(afternoon_lerp_time, "afternoon_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(dusk_lerp_time, "dusk_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(night_lerp_time, "night_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(midnight_lerp_time, "midnight_lerp_time not properly instantiated in DayNightModulator.gd")
	assert(late_night_lerp_time, "late_night_lerp_time not properly instantiated in DayNightModulator.gd")
