class_name AnzhuCharacter extends CharacterBody2D #_AnzhuCharacter.gd
signal has_died(is_playing_music :bool)
const NEW_SAFE_MARGIN :float = 0.05

enum AnimalType {Walrus, Owl, Human,  Bear, Fox, Hare, Wolf, Reindeer}
var move_speed :int
enum Sleepiness {Awake, Drowsy, Tired, Exhausted, Deprived}
enum SleepSchedule {Diurnal,Nocturnal,Crepuscular}
enum MaxHits {One, Two, Four, Eight}
var max_health :int

@export_group("Core Attributes")
@export var this_animals_type :AnimalType = AnimalType.Walrus
@export var starting_health :MaxHits = MaxHits.One
@export var set_sleep_schedule :SleepSchedule = SleepSchedule.Diurnal
@export var is_sleeping :bool = false
@onready var day_night :DayNighton = DayNighton
var anim :AnimatedSprite2D
var stats :CollisionShape2D
var audio :Node2D
var parent
var is_injured :bool = false
var is_stunned :bool = false
var current_melatonin :float
var time_since_last_sleep :float = 0.0
var daynight_dictionary :Dictionary
var scenes_nodes :Dictionary[String, Node]

func create_and_ship_scenes_nodes()->void:
	scenes_nodes["parent"] = self
	scenes_nodes["ex_elevation"] = %ElevationsLayer
	scenes_nodes["ex_tracks"] = %SnowTracksLayer
	scenes_nodes["Player"] = %Player
	for child in get_children():
		scenes_nodes[child.name] = child
	for child_name in scenes_nodes:
		var child_node = scenes_nodes[child_name]
		if child_node.get("node_dictionary") != null and child_name != self.name:
			child_node.node_dictionary = scenes_nodes
	anim = scenes_nodes['Animations']
	stats = scenes_nodes['Stats']
	audio = scenes_nodes['AudioManager']
	parent = get_parent()

func _characters_dictionary_inbox(incoming_delivery :Dictionary)->void:
	daynight_dictionary = incoming_delivery
	day_night.time_dictionary_delivery.disconnect(_characters_dictionary_inbox)

func get_daynight_dictionary()->Dictionary:
	return daynight_dictionary

func _ready()->void:
	add_to_group("being")
	set_motion_mode(MOTION_MODE_FLOATING)
	set_safe_margin(NEW_SAFE_MARGIN)
	day_night.time_dictionary_delivery.connect(_characters_dictionary_inbox)
	day_night.time_progressed.connect(time_progressed)
	move_speed = match_move_speed()
	max_health = match_max_hits()
	create_and_ship_scenes_nodes()
	ready()
func ready()->void: pass

func time_progressed(current_time :DayNighton.TimeOfDay)->void:
	_process_melatonin(current_time)
	virtual_progress_time(current_time)
func virtual_progress_time(current_time :DayNighton.TimeOfDay)->void: pass

func _process_melatonin(current_time :DayNighton.TimeOfDay)->void:
	if is_sleeping:
		time_since_last_sleep = 0.0
		return
	var time_data :Dictionary = daynight_dictionary[current_time]
	match_sleep_schedule_for_melatonin(time_data["melatonin_value"])
	time_since_last_sleep += time_data["modulate_duration"]/60.0

func match_sleep_schedule_for_melatonin(base_melatonin :int)->void:
	match set_sleep_schedule:
		SleepSchedule.Diurnal:
			_adjust_melatonin(base_melatonin)
		SleepSchedule.Nocturnal:
			_adjust_melatonin(-base_melatonin)
		SleepSchedule.Crepuscular:
			_adjust_melatonin(abs(base_melatonin)-3.0)

func _adjust_melatonin(base_melatonin :int)->void:
	current_melatonin = clamp(current_melatonin + base_melatonin, -3,3)

func match_move_speed()->int:
	match this_animals_type:
		AnimalType.Walrus:   return 5
		AnimalType.Owl:      return 15
		AnimalType.Human:    return 16
		AnimalType.Bear:     return 10
		AnimalType.Fox:      return 40
		AnimalType.Hare:     return 45
		AnimalType.Wolf:     return 50
		AnimalType.Reindeer: return 55
		_:
			print_rich("[color=red][b]match_move_speed in, ", self.name, ", resulted in 0[/b][/color]")
			return 0

func match_max_hits()->int:
	match starting_health:
		MaxHits.One: return 1
		MaxHits.Two: return 2
		MaxHits.Four: return 4
		MaxHits.Eight: return 8
		_:
			print_rich("[color=red][b]match_max_hits in, ", self.name, ", resulted in 0[/b][/color]")
			return 0
