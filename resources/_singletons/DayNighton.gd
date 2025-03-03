extends Node #DayNighton.gd
signal time_progressed(current_time)
signal time_dictionary_delivery(time_of_day_dictionary)
enum TimeOfDay{DAWN,MORNING,NOON,AFTERNOON,DUSK,NIGHT,MIDNIGHT,LATE_NIGHT}
var time_of_day_dictionary = {}
var current_time :TimeOfDay = TimeOfDay.DAWN

func progress_time(incoming_time = current_time)->void:
	current_time = incoming_time # this is setup so initialization works. looks confusing without checking out DayNightModulator
	match current_time:
		TimeOfDay.DAWN:
			current_time = TimeOfDay.MORNING
		TimeOfDay.MORNING:
			current_time = TimeOfDay.NOON
		TimeOfDay.NOON:
			current_time = TimeOfDay.AFTERNOON
		TimeOfDay.AFTERNOON:
			current_time = TimeOfDay.DUSK
		TimeOfDay.DUSK:
			current_time = TimeOfDay.NIGHT
		TimeOfDay.NIGHT:
			current_time = TimeOfDay.MIDNIGHT
		TimeOfDay.MIDNIGHT:
			current_time = TimeOfDay.LATE_NIGHT
		TimeOfDay.LATE_NIGHT:
			current_time = TimeOfDay.DAWN
	time_progressed.emit(current_time)

func initialize(modulator :CanvasModulate)->void:
	time_of_day_dictionary = {
		TimeOfDay.DAWN: {
			"name": "Dawn",
			"modulate": modulator.dawn_amount,
			"modulate_duration": modulator.init_time_lerp[0],
			"melatonin_value": 0,
		},
		TimeOfDay.MORNING: {
			"name": "Morning",
			"modulate": modulator.morning_amount,
			"modulate_duration": modulator.init_time_lerp[1],
			"melatonin_value": -1,
		},
		TimeOfDay.NOON: {
			"name": "Noon",
			"modulate": modulator.noon_amount,
			"modulate_duration": modulator.init_time_lerp[2],
			"melatonin_value": -2,
		},
		TimeOfDay.AFTERNOON: {
			"name": "Afternoon",
			"modulate": modulator.afternoon_amount,
			"modulate_duration": modulator.init_time_lerp[3],
			"melatonin_value": -3,
		},
		TimeOfDay.DUSK: {
			"name": "Dusk",
			"modulate": modulator.dusk_amount,
			"modulate_duration": modulator.init_time_lerp[4],
			"melatonin_value": 0,
		},
		TimeOfDay.NIGHT: {
			"name": "Night",
			"modulate": modulator.night_amount,
			"modulate_duration": modulator.init_time_lerp[5],
			"melatonin_value": 2,
		},
		TimeOfDay.MIDNIGHT: {
			"name": "Midnight",
			"modulate": modulator.midnight_amount,
			"modulate_duration": modulator.init_time_lerp[6],
			"melatonin_value": 3,
		},
		TimeOfDay.LATE_NIGHT: {
			"name": "Late Night",
			"modulate": modulator.late_night_amount,
			"modulate_duration": modulator.init_time_lerp[7],
			"melatonin_value": 1,
		}
	}
	time_dictionary_delivery.emit(time_of_day_dictionary)
