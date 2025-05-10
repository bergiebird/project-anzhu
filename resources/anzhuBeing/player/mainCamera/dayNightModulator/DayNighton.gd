extends Node #DayNighton.gd
signal new_hour
signal time_progressed(TimeOfDay)
signal time_progressed_name(String)
signal time_progressed_melatonin(int)
signal time_dictionary_delivery(Dictionary)
signal time_progressed_nightlight(bool)
signal time_progressed_campfire(float)
enum TimeOfDay{DAWN, MORNING, NOON, AFTERNOON, DUSK, NIGHT, MIDNIGHT, LATE_NIGHT}
enum SunAmount{Most=-3, Great=-2, Good=-1, Alright=0,ItWillComeBack=1,MissingSun=2, WhatIsThisSunYouSpeakOf=3}
const WORLD_TIMER_WAIT_TIME :int = 180
var time_dictionary :Dictionary = {
		TimeOfDay.DAWN: {
			"name": "Dawn",
			"modulate": 170,
			"modulate_duration":null,
			"melatonin_value": SunAmount.Alright,
			"next_time": TimeOfDay.MORNING,
			"night_lights_on": false,
			"camp_fire_energy":0.3,
		},
		TimeOfDay.MORNING: {
			"name": "Morning",
			"modulate": 250,
			"modulate_duration":null,
			"melatonin_value": SunAmount.Good,
			"next_time": TimeOfDay.NOON,
			"night_lights_on": false,
			"camp_fire_energy":0.2,
		},
		TimeOfDay.NOON: {
			"name": "Noon",
			"modulate": 255,
			"modulate_duration":null,
			"melatonin_value": SunAmount.Great,
			"next_time": TimeOfDay.AFTERNOON,
			"night_lights_on": false,
			"camp_fire_energy":0.1,
		},
		TimeOfDay.AFTERNOON: {
			"name": "Afternoon",
			"modulate": 254,
			"modulate_duration":null,
			"melatonin_value": SunAmount.Most,
			"next_time": TimeOfDay.DUSK,
			"night_lights_on": false,
			"camp_fire_energy":0.1,
		},
		TimeOfDay.DUSK: {
			"name": "Dusk",
			"modulate": 170,
			"modulate_duration":null,
			"melatonin_value": SunAmount.Alright,
			"next_time": TimeOfDay.NIGHT,
			"night_lights_on": false,
			"camp_fire_energy":0.3,
		},
		TimeOfDay.NIGHT: {
			"name": "Night",
			"modulate": 100,
			"modulate_duration":null,
			"melatonin_value": SunAmount.MissingSun,
			"next_time": TimeOfDay.MIDNIGHT,
			"night_lights_on": true,
			"camp_fire_energy":0.4,
		},
		TimeOfDay.MIDNIGHT: {
			"name": "Midnight",
			"modulate": 97,
			"modulate_duration":null,
			"melatonin_value": SunAmount.WhatIsThisSunYouSpeakOf,
			"next_time": TimeOfDay.LATE_NIGHT,
			"night_lights_on": true,
			"camp_fire_energy":0.5,
		},
		TimeOfDay.LATE_NIGHT: {
			"name": "Late Night",
			"modulate": 100,
			"modulate_duration":null,
			"melatonin_value": SunAmount.WhatIsThisSunYouSpeakOf,
			"next_time": TimeOfDay.DAWN,
			"night_lights_on": true,
			"camp_fire_energy":0.6,
		}
	}
var current_time: TimeOfDay = TimeOfDay.DAWN
var night_lights_on :bool
@onready var world_timer :Timer = Timer.new()

func _ready()->void:
	world_timer.wait_time = WORLD_TIMER_WAIT_TIME
	world_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	world_timer.autostart = true
	world_timer.timeout.connect(progress_time)
	add_child(world_timer)
	call_deferred("progress_for_campfire")

func progress_for_campfire()->void:
	time_progressed_campfire.emit(time_dictionary[current_time]['camp_fire_energy'])

func progress_time(_incoming_time :TimeOfDay=current_time)->void:
	current_time = time_dictionary[current_time]["next_time"]
	var dict :Dictionary = time_dictionary[current_time]
	new_hour.emit()
	time_progressed.emit(current_time)
	time_progressed_name.emit(dict["name"])
	time_progressed_melatonin.emit(dict['melatonin_value'])
	time_progressed_nightlight.emit(dict['night_lights_on'])
	time_progressed_campfire.emit(dict['camp_fire_energy'])

func initialize(mod :DayNightModulator)->Dictionary:
	time_dictionary[TimeOfDay.DAWN]["modulate_duration"]       = mod.init_time_lerp[TimeOfDay.DAWN]
	time_dictionary[TimeOfDay.MORNING]["modulate_duration"]    = mod.init_time_lerp[TimeOfDay.MORNING]
	time_dictionary[TimeOfDay.NOON]["modulate_duration"]       = mod.init_time_lerp[TimeOfDay.NOON]
	time_dictionary[TimeOfDay.AFTERNOON]["modulate_duration"]  = mod.init_time_lerp[TimeOfDay.AFTERNOON]
	time_dictionary[TimeOfDay.DUSK]["modulate_duration"]       = mod.init_time_lerp[TimeOfDay.DUSK]
	time_dictionary[TimeOfDay.NIGHT]["modulate_duration"]      = mod.init_time_lerp[TimeOfDay.NIGHT]
	time_dictionary[TimeOfDay.MIDNIGHT]["modulate_duration"]   = mod.init_time_lerp[TimeOfDay.MIDNIGHT]
	time_dictionary[TimeOfDay.LATE_NIGHT]["modulate_duration"] = mod.init_time_lerp[TimeOfDay.LATE_NIGHT]
	time_dictionary_delivery.emit(time_dictionary)
	return time_dictionary


#region	DEBUG

var debug :bool = false
#endregion
