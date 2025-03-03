class_name AnzhuCharacter extends CharacterBody2D #AnzhuCharacter.gd
var daynight_dictionary :Dictionary
enum Goals {GetSleep,FindFood,FindWater,Nothing,Hunt}
enum Actions {Idle,Sit,Hit,Wander,Chase,Dead,Search,Charge,Sleep}
enum SleepSchedule {Diurnal,Nocturnal,Crepuscular}
enum Sleepiness {Awake, Drowsy, Tired, Exhausted, Deprived}
@export_group("Core Attributes")
@export var is_sleeping :bool = false
@export var move_speed :int = 10
@export var starting_health :int = 8
@export var starting_goal :Goals = Goals.Nothing
@export var set_sleep_schedule :SleepSchedule = SleepSchedule.Diurnal
var current_melatonin :float
var current_action :Actions
var current_goal :Goals
var time_since_last_sleep :float = 0.0


func _characters_dictionary_inbox(incoming_delivery:Dictionary)->void:
	daynight_dictionary = incoming_delivery
func get_daynight_dictionary()->Dictionary:
	return daynight_dictionary

func _ready() -> void:
	set_motion_mode(MOTION_MODE_FLOATING)
	DayNighton.time_dictionary_delivery.connect(_characters_dictionary_inbox)
	DayNighton.time_progressed.connect(_process_melatonin)
	current_goal = starting_goal
	current_action = Actions.Idle
	ready()
func ready()->void: pass

func _process_melatonin(current_time)->void: #checks if dict exists, figures out its sleep_schedule, then adds to
	if daynight_dictionary.is_empty():
		print_rich("[color=red][b]daynight_dictionary is empty[/b][/color]" + self.name)
		return
	if is_sleeping:
		time_since_last_sleep = 0.0
		return
	var time_data = daynight_dictionary[current_time]
	var base_melatonin = time_data["melatonin_value"]
	match set_sleep_schedule:
		SleepSchedule.Diurnal:
			_adjust_melatonin(base_melatonin)
		SleepSchedule.Nocturnal:
			_adjust_melatonin(-base_melatonin)
		SleepSchedule.Diurnal:
			_adjust_melatonin(abs(base_melatonin)-3.0)
	time_since_last_sleep += time_data["modulate_duration"]/60.0

func _adjust_melatonin(base_melatonin)->void:
	current_melatonin = clamp(current_melatonin + base_melatonin, -3,3)
