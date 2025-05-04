extends Node #DayNighton.gd
signal time_progressed(current_time :TimeOfDay)
signal time_dictionary_delivery(time_dictionary :Dictionary)
signal turn_on_night_lights(should_be_on :bool)
enum TimeOfDay{DAWN, MORNING, NOON, AFTERNOON, DUSK, NIGHT, MIDNIGHT, LATE_NIGHT}
const WORLD_TIMER_WAIT_TIME :int = 180
var time_dictionary :Dictionary = {
		TimeOfDay.DAWN: {
			"name": "Dawn",
			"modulate": 170,
			"modulate_duration":null,
			"melatonin_value": 0,
			"next_time": TimeOfDay.MORNING,
			"night_lights_on": false,
		},
		TimeOfDay.MORNING: {
			"name": "Morning",
			"modulate": 250,
			"modulate_duration":null,
			"melatonin_value": -1,
			"next_time": TimeOfDay.NOON,
			"night_lights_on": false,
		},
		TimeOfDay.NOON: {
			"name": "Noon",
			"modulate": 255,
			"modulate_duration":null,
			"melatonin_value": -2,
			"next_time": TimeOfDay.AFTERNOON,
			"night_lights_on": false,
		},
		TimeOfDay.AFTERNOON: {
			"name": "Afternoon",
			"modulate": 254,
			"modulate_duration":null,
			"melatonin_value": -3,
			"next_time": TimeOfDay.DUSK,
			"night_lights_on": false,
		},
		TimeOfDay.DUSK: {
			"name": "Dusk",
			"modulate": 170,
			"modulate_duration":null,
			"melatonin_value": 0,
			"next_time": TimeOfDay.NIGHT,
			"night_lights_on": false,
		},
		TimeOfDay.NIGHT: {
			"name": "Night",
			"modulate": 100,
			"modulate_duration":null,
			"melatonin_value": 2,
			"next_time": TimeOfDay.MIDNIGHT,
			"night_lights_on": true,
		},
		TimeOfDay.MIDNIGHT: {
			"name": "Midnight",
			"modulate": 97,
			"modulate_duration":null,
			"melatonin_value": 3,
			"next_time": TimeOfDay.LATE_NIGHT,
			"night_lights_on": true,
		},
		TimeOfDay.LATE_NIGHT: {
			"name": "Late Night",
			"modulate": 100,
			"modulate_duration":null,
			"melatonin_value": 1,
			"next_time": TimeOfDay.DAWN,
			"night_lights_on": true,
		}
	}
var current_time: TimeOfDay = TimeOfDay.DAWN
var night_lights_on :bool
@onready var world_timer :Timer = Timer.new()

func _ready()->void:
	world_timer.wait_time = WORLD_TIMER_WAIT_TIME
	world_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	world_timer.autostart = true
	Debuggerton.signal_checker([
		world_timer.timeout.connect(progress_time)])
	add_child(world_timer)

func progress_time(_incoming_time :TimeOfDay=current_time)->void:
	current_time = time_dictionary[current_time]["next_time"]
	night_lights_on = time_dictionary[current_time]["night_lights_on"]
	time_progressed.emit(current_time)

func initialize(mod :DayNightModulator)->Dictionary:
	time_dictionary[TimeOfDay.DAWN]      ["modulate_duration"] = mod.init_time_lerp[TimeOfDay.DAWN]
	time_dictionary[TimeOfDay.MORNING]   ["modulate_duration"] = mod.init_time_lerp[TimeOfDay.MORNING]
	time_dictionary[TimeOfDay.NOON]      ["modulate_duration"] = mod.init_time_lerp[TimeOfDay.NOON]
	time_dictionary[TimeOfDay.AFTERNOON] ["modulate_duration"] = mod.init_time_lerp[TimeOfDay.AFTERNOON]
	time_dictionary[TimeOfDay.DUSK]      ["modulate_duration"] = mod.init_time_lerp[TimeOfDay.DUSK]
	time_dictionary[TimeOfDay.NIGHT]     ["modulate_duration"] = mod.init_time_lerp[TimeOfDay.NIGHT]
	time_dictionary[TimeOfDay.MIDNIGHT]  ["modulate_duration"] = mod.init_time_lerp[TimeOfDay.MIDNIGHT]
	time_dictionary[TimeOfDay.LATE_NIGHT]["modulate_duration"] = mod.init_time_lerp[TimeOfDay.LATE_NIGHT]
	time_dictionary_delivery.emit(time_dictionary)
	return time_dictionary

###
##	DEBUG
###
var debug :bool = false

func _debug()->void:
	assert(time_progressed)
	assert(time_dictionary_delivery)
	assert(turn_on_night_lights)
