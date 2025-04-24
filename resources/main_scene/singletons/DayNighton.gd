extends Node #DayNighton.gd
signal time_progressed(current_time :TimeOfDay)
signal time_dictionary_delivery(time_dictionary :Dictionary)
signal turn_on_night_lights(should_be_on :bool)
enum TimeOfDay{DAWN, MORNING, NOON, AFTERNOON, DUSK, NIGHT, MIDNIGHT, LATE_NIGHT}
var time_dictionary = {}
var current_time: TimeOfDay = TimeOfDay.DAWN
var night_lights_on :bool

func progress_time(incoming_time :TimeOfDay=current_time)->void:
	current_time = incoming_time
	match current_time:
		TimeOfDay.DAWN:
			current_time = TimeOfDay.MORNING
			night_lights_on = false
		TimeOfDay.MORNING:
			current_time = TimeOfDay.NOON
			night_lights_on = false
		TimeOfDay.NOON:
			current_time = TimeOfDay.AFTERNOON
			night_lights_on = false
		TimeOfDay.AFTERNOON:
			current_time = TimeOfDay.DUSK
			night_lights_on = false
		TimeOfDay.DUSK:
			current_time = TimeOfDay.NIGHT
			night_lights_on = true
		TimeOfDay.NIGHT:
			current_time = TimeOfDay.MIDNIGHT
			night_lights_on = true
		TimeOfDay.MIDNIGHT:
			current_time = TimeOfDay.LATE_NIGHT
			night_lights_on = true
		TimeOfDay.LATE_NIGHT:
			current_time = TimeOfDay.DAWN
			night_lights_on = false
	time_progressed.emit(current_time)

func initialize(modulator :CanvasModulate)->Dictionary:
	time_dictionary = {
		TimeOfDay.DAWN: {
			"name": "Dawn",
			"modulate": 170,
			"modulate_duration": modulator.init_time_lerp[TimeOfDay.DAWN],
			"melatonin_value": 0,
		},
		TimeOfDay.MORNING: {
			"name": "Morning",
			"modulate": 250,
			"modulate_duration": modulator.init_time_lerp[TimeOfDay.MORNING],
			"melatonin_value": -1,
		},
		TimeOfDay.NOON: {
			"name": "Noon",
			"modulate": 255,
			"modulate_duration": modulator.init_time_lerp[TimeOfDay.NOON],
			"melatonin_value": -2,
		},
		TimeOfDay.AFTERNOON: {
			"name": "Afternoon",
			"modulate": 254,
			"modulate_duration": modulator.init_time_lerp[TimeOfDay.AFTERNOON],
			"melatonin_value": -3,
		},
		TimeOfDay.DUSK: {
			"name": "Dusk",
			"modulate": 170,
			"modulate_duration": modulator.init_time_lerp[TimeOfDay.DUSK],
			"melatonin_value": 0,
		},
		TimeOfDay.NIGHT: {
			"name": "Night",
			"modulate": 100,
			"modulate_duration": modulator.init_time_lerp[TimeOfDay.NIGHT],
			"melatonin_value": 2,
		},
		TimeOfDay.MIDNIGHT: {
			"name": "Midnight",
			"modulate": 97,
			"modulate_duration": modulator.init_time_lerp[TimeOfDay.MIDNIGHT],
			"melatonin_value": 3,
		},
		TimeOfDay.LATE_NIGHT: {
			"name": "Late Night",
			"modulate": 100,
			"modulate_duration": modulator.init_time_lerp[TimeOfDay.LATE_NIGHT],
			"melatonin_value": 1,
		}
	}
	time_dictionary_delivery.emit(time_dictionary)
	return time_dictionary
