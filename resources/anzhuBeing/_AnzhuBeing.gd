class_name AnzhuBeing extends CharacterBody2D #_AnzhuBeing.gd
signal has_died
signal on_new_track_tile (new_tile_coordinates :Vector2i)
signal hit_over
signal striking (attacking_who :AnzhuBeing, who_is_attacking :AnzhuBeing, what_weapon)
signal was_struck
signal direction_changed(new_direction)
enum AnimalType {Walrus, Owl, Human,  Bear, Fox, Hare, Wolf, Reindeer}
enum MaxHits {One, Two, Four, Eight}
const NEW_SAFE_MARGIN :float = 0.05
@export_group("Core Attributes")
@export var this_animals_type :AnimalType = AnimalType.Walrus
@export var starting_health :MaxHits = MaxHits.One
var max_health :int
var move_speed :int
var anim :AnimatedSprite2D
var audio :Node2D
var is_sliding :bool = false
var is_injured :bool = false
var is_stunned :bool = false
var daynight_dictionary :Dictionary
var last_known_tile_coords :Vector2i
var scenes_nodes :Dictionary[String, Node]
var personal_track_map :TileMapLayer
var entities_manager :CanvasGroup
var player :Player
@onready var elevation_map :TileMapLayer = %ElevationsLayer
@onready var mask :CollisionShape2D = $Mask
### READY #################################

func _ready()->void:
	initialize_debugging()
	setup_basics()
	signaler()
	create_and_ship_scene_nodes()
	character_ready()

func setup_basics()->void:
	add_to_group("being")
	set_motion_mode(MOTION_MODE_FLOATING)
	set_safe_margin(NEW_SAFE_MARGIN)
	move_speed = match_move_speed()
	max_health = match_max_hits()

func create_and_ship_scene_nodes()->void:
	scenes_nodes["ex_elevation"] = elevation_map
	scenes_nodes["scene_root"] = self
	scenes_nodes = Libraryton.getChildren_filterDictionary(scenes_nodes, self, debug_lambda)
	for child_name in scenes_nodes:
		var child_node :Node = scenes_nodes[child_name]
		if child_node != null and child_name != self.name:
			if child_node.get("node_dictionary") != null:
				child_node.node_dictionary = scenes_nodes
	anim = scenes_nodes['Animations']
	audio = scenes_nodes['AudioManager']

func signaler()->void:
	DayNighton.time_dictionary_delivery.connect(_characters_dictionary_inbox)
	DayNighton.time_progressed.connect(time_progressed)
	Libraryton.entities_reference.connect(func(ref): entities_manager = ref)
	Libraryton.player_reference.connect(func(ref): player = ref)
	was_struck.connect(process_character_strike)
	has_died.connect(how_should_character_die)
	character_signaler()

func _characters_dictionary_inbox(incoming_delivery :Dictionary)->void:
	daynight_dictionary = incoming_delivery
	DayNighton.time_dictionary_delivery.disconnect(_characters_dictionary_inbox)

# Make a .tres for animal stats, will cut this matching code down by a ton.
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
	character_process(delta)

func _physics_process(delta: float) -> void:
	__physics_process(delta)
	check_current_tile()
	move_and_slide()

func check_current_tile(is_tile_forced :bool=false)->void:
	if personal_track_map:
		var current_tile_coords :Vector2i = personal_track_map.local_to_map(personal_track_map.to_local(global_position + Vector2(0,1.4)))
		if current_tile_coords != last_known_tile_coords or is_tile_forced:
			last_known_tile_coords = current_tile_coords
			on_new_track_tile.emit(current_tile_coords)


### Signals ####################################

func time_progressed(current_time :DayNighton.TimeOfDay)->void:
	if debug_self: print_rich('[color=eaf1f0] Time has progressed')
	character_time_progressed(current_time)

###Attack Functions###

func strike_target(damage,weapon,who:AnzhuBeing)->void:
	striking.emit()
	who.was_just_struck(damage,weapon,self)

func was_just_struck(damage,weapon,who:AnzhuBeing):
	if parse_incoming_damage(damage,weapon,who):
		process_character_strike()
		was_struck.emit()

func parse_incoming_damage(damage,weapon,who:AnzhuBeing)->bool:
	return true

###Map Functions ###

func current_character_elevation(target :Vector2 = Vector2.ZERO)->Dictionary:
	var current_coordinates = elevation_map.local_to_map(elevation_map.to_local(target + global_position))
	var current_elevation = elevation_map.get_cell_tile_data(current_coordinates).get_custom_data_by_layer_id(0)
	return {"Coordinate":current_coordinates, "Elevation":current_elevation}


###VIRTUALS####################################
func __physics_process(delta:float)->void:pass
func how_should_character_die(): pass
func character_signaler(): pass
func character_ready(): pass
func early_ready_for_debug(): pass
func character_process(delta:float):pass
func character_time_progressed(current_time :DayNighton.TimeOfDay): pass
func process_character_strike():pass
func character_was_hit_over(): pass
###VIRTUALS####################################

@export_group('DEBUG')
@export var debug_all :bool = false
@export var debug_self :bool = false
var debug_icon :String
var debug_lambda :Callable = func(child): if child.has_method('debug'): child.debug()
func initialize_debugging():
	if debug_self or debug_all:
		debug_self = true
	else:
		debug_lambda = func(child):pass
	early_ready_for_debug()
