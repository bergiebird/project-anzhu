class_name AnzhuCharacter extends CharacterBody2D #_AnzhuCharacter.gd
signal has_died
signal on_new_tile (new_tile_coordinates :Vector2i)
signal hit_over
signal striking (attacking_who :AnzhuCharacter, who_is_attacking :AnzhuCharacter, what_weapon)
signal was_struck

const NEW_SAFE_MARGIN :float = 0.05
enum AnimalType {Walrus, Owl, Human,  Bear, Fox, Hare, Wolf, Reindeer}
enum MaxHits {One, Two, Four, Eight}

@export_group("Core Attributes")
@export var this_animals_type :AnimalType = AnimalType.Walrus
@export var starting_health :MaxHits = MaxHits.One
@onready var track_manager :CanvasGroup = %Tracks
@onready var snow_tile_map :TileMapLayer = %Snow
var personal_track_map
var debug_icon :String
var max_health :int
var move_speed :int
var anim :AnimatedSprite2D
var mask :CollisionShape2D
var audio :Node2D
var parent :CanvasGroup
var is_injured :bool = false
var is_stunned :bool = false
var daynight_dictionary :Dictionary
var scenes_nodes :Dictionary[String, Node]

### READY #################################

func _ready()->void:
	initialize_debugging()
	setup_basics()
	signal_connector()
	create_and_ship_scenes_nodes()
	character_ready()

func setup_basics()->void:
	add_to_group("being")
	set_motion_mode(MOTION_MODE_FLOATING)
	set_safe_margin(NEW_SAFE_MARGIN)
	personal_track_map = track_manager.create_track_map(self.name)
	move_speed = match_move_speed()
	max_health = match_max_hits()

func create_and_ship_scenes_nodes()->void:
	scenes_nodes["ex_elevation"] = %ElevationsLayer #global nodes, place in Singleton LATER
	scenes_nodes["Player"] = %Player #place in Libraryton
	scenes_nodes["scene_root"] = self
	for child in get_children():
		scenes_nodes[child.name] = child
		if debug_all and child.has_method('debug'):
			child.debug()
	for child_name in scenes_nodes:
		var child_node :Node = scenes_nodes[child_name]
		if child_node.get("node_dictionary") != null and child_name != self.name:
			child_node.node_dictionary = scenes_nodes
	anim = scenes_nodes['Animations']
	mask = scenes_nodes['Mask']
	audio = scenes_nodes['AudioManager']
	parent = get_parent()

func signal_connector()->void:
	DayNighton.time_dictionary_delivery.connect(_characters_dictionary_inbox)
	DayNighton.time_progressed.connect(time_progressed)
	was_struck.connect(process_character_strike)
	hit_over.connect(character_hit_over)
	has_died.connect(how_should_character_die)

func _characters_dictionary_inbox(incoming_delivery :Dictionary)->void:
	daynight_dictionary = incoming_delivery
	DayNighton.time_dictionary_delivery.disconnect(_characters_dictionary_inbox)

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

### PROCESS ####################################

func _process(delta:float)->void:
	check_current_tile()
	character_process(delta)

func check_current_tile()->void:
	if snow_tile_map != null:
		pass

### Signals ####################################

func time_progressed(current_time :DayNighton.TimeOfDay)->void:
	if debug_self:
		print_rich('[color=eaf1f0] Time has progressed')
	#_process_melatonin(current_time)
	character_time_progressed(current_time)


#enum Sleepiness {Awake, Drowsy, Tired, Exhausted, Deprived}
#enum SleepSchedule {Diurnal,Nocturnal,Crepuscular}
#@export var set_sleep_schedule :SleepSchedule = SleepSchedule.Diurnal
#@export var is_sleeping :bool = false
#var current_melatonin :float
#var time_since_last_sleep :float = 0.0
#func _process_melatonin(current_time :DayNighton.TimeOfDay)->void:
	#if is_sleeping:
		#time_since_last_sleep = 0.0
		#return
	#var time_data :Dictionary = daynight_dictionary[current_time]
	#match_sleep_schedule_for_melatonin(time_data["melatonin_value"])
	#time_since_last_sleep += time_data["modulate_duration"]/60.0
#
#func match_sleep_schedule_for_melatonin(base_melatonin :int)->void:
	#match set_sleepS._schedule:
		#SleepSchedule.Diurnal:
			#_adjust_melatonin(base_melatonin)
		#SleepSchedule.Nocturnal:
			#_adjust_melatonin(-base_melatonin)
		#SleepSchedule.Crepuscular:
			#_adjust_melatonin(abs(base_melatonin)-3.0)
#
#func _adjust_melatonin(base_melatonin :int)->void:
	#current_melatonin = clamp(current_melatonin + base_melatonin, -3,3)


func communicate_to(name_of_node :String, name_of_function :String, arguments :Array)->void:
	pass





###Attack Functions###

func strike_target(damage,weapon,who:AnzhuCharacter)->void:
	striking.emit()
	who.was_just_struck(damage,weapon,self)
func was_just_struck(damage,weapon,who:AnzhuCharacter):
	if parse_incoming_damage(damage,weapon,who):
		process_character_strike()
		was_struck.emit()
func parse_incoming_damage(damage,weapon,who:AnzhuCharacter)->bool:
	return true
func process_character_strike():pass
func character_hit_over(): pass


###VIRTUALS####################################
func how_should_character_die(): pass
func character_ready(): pass
func early_ready_for_debug(): pass
func character_process(delta:float):pass
func character_time_progressed(current_time :DayNighton.TimeOfDay): pass

###VIRTUALS####################################

@export_group('DEBUG')
@export var debug_all :bool = false
@export var debug_self :bool = false

func initialize_debugging():
	if debug_self or debug_all: debug_self = true
	early_ready_for_debug()
