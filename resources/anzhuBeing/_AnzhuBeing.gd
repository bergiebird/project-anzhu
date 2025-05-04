class_name AnzhuBeing extends CharacterBody2D #_AnzhuBeing.gd

signal made_loud_noise (who :AnzhuBeing, how_loud :float)
signal has_died
signal on_new_track_tile (new_tile_coordinates :Vector2i)
signal hit_over
signal striking (attacking_who :AnzhuBeing, who_is_attacking :AnzhuBeing, what_weapon :Variant)
signal was_struck

enum PersonalDirection {NORTH,SOUTH,EAST,WEST}
signal direction_should_flip(should_flip :bool)
signal direction_changed(direction_int :int)
signal direction_changed_named(direction_string :String)
var current_direction :int:
	set(value): if current_direction != value:
		current_direction = value
		var named_direction :String = Directon.get_current_direction(current_direction)
		direction_should_flip.emit(Directon.get_personal_should_flip(named_direction))
		direction_changed.emit(current_direction)
		direction_changed_named.emit(named_direction)
var velocity_force :Vector2
var old_velocity_force :Vector2
const MAX_FORCE :Vector2 = Vector2(100,100)

enum AnimalType {Walrus, Owl, Human,  Bear, Fox, Hare, Wolf, Reindeer}
const ANIMAL_NAMES :Array[String] = ["Walrus", "Owl", "Human",  "Bear", "Fox", "Hare", "Wolf", "Reindeer"]

var personal_stats :Dictionary
var max_health :int
var move_speed :int
var animal_icon :String
var animal_name :String:
	set(value): if value != animal_name:
		animal_name = value
		add_to_group(animal_name)
		animal_icon = "[img]res://resources" +animal_name+"/"+animal_name+".png[/img]"
		personal_stats = Staton.ANIMAL_INFO[animal_name]
		move_speed = personal_stats["BaseMoveSpeed"]
		max_health = personal_stats["StartingHealth"]

const NEW_SAFE_MARGIN :float = 0.05
@export var this_animals_type :AnimalType
var anim :AnimatedSprite2D
var audio :Node2D

signal sliding(is_sliding :bool)
var is_sliding :bool = false:
	set(value): if value!=is_sliding:
		is_sliding = value
		sliding.emit(is_sliding)

signal injured(is_injured :bool)
var is_injured :bool = false:
	set(value): if value!=is_injured:
		is_injured = value
		injured.emit(is_injured)

signal stunned(is_stunned :bool)
var is_stunned :bool = false:
	set(value): if value!=is_stunned:
		is_stunned = value
		stunned.emit(is_stunned)

var daynight_dictionary :Dictionary
var scenes_nodes :Dictionary[String, Node]
var player :Player
var being_process_array :Array[Node]
var being_physics_process_array :Array[Node]

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
	animal_name = ANIMAL_NAMES[this_animals_type]
	current_direction = PersonalDirection.EAST

func create_and_ship_scene_nodes()->void:
	scenes_nodes["scene_root"] = self
	scenes_nodes = Libraryton.getChildren_filterDictionary(scenes_nodes, self, debug_lambda)
	for child_name :String in scenes_nodes:
		var child_node :Node = scenes_nodes[child_name]
		if child_node != null and child_name != self.name:
			if child_node.get("node_dictionary") != null:      child_node.node_dictionary = scenes_nodes
			if child_node.has_method("being_process"):         being_process_array.append(child_node)
			if child_node.has_method("being_physics_process"): being_physics_process_array.append(child_node)
	anim = scenes_nodes['Animations']
	audio = scenes_nodes['AudioManager']

func signaler()->void:
	Debuggerton.signal_checker([
		DayNighton.time_dictionary_delivery.connect(func(delivery :Dictionary)->void:daynight_dictionary = delivery),
		DayNighton.time_progressed.connect(time_progressed),
		Libraryton.player_reference.connect(func(ref :Player)->void:player = ref),
		was_struck.connect(process_character_strike),
		has_died.connect(how_should_character_die)
	], debug_self)
	character_signaler()

### PROCESS ####################################

func _process(delta:float)->void:
	character_process(delta)
	for being :Node in being_process_array:
		being.being_process(delta)

func _physics_process(delta: float) -> void:
	__physics_process(delta)
	for being :Node in being_physics_process_array:
		being.being_physics_process(delta)
	velocity_force_filter_for_direction(delta)
	if move_and_slide():
		pass #Place collision with wall code here

func velocity_force_filter_for_direction(delta:float)->void:
	if self is Player:
		return
	if velocity_force != Vector2.ZERO:
		var new_direction :int = Directon.get_prevalent_direction(velocity_force)
		if current_direction != new_direction: current_direction = new_direction
	match current_direction:
		PersonalDirection.NORTH:
			velocity.y -= velocity_force.y * delta
		PersonalDirection.SOUTH:
			velocity.y += velocity_force.y *delta
		PersonalDirection.EAST:
			velocity.x += velocity_force.x *delta
		PersonalDirection.WEST:
			velocity.x -= velocity_force.x *delta
	velocity_force = Vector2.ZERO



### Signals ####################################

func time_progressed(current_time :DayNighton.TimeOfDay)->void:
	if debug_self:
		print_rich('[color=eaf1f0] Time has progressed')
	character_time_progressed(current_time)

###Attack Functions###

func strike_target(damage :int, weapon :String, who:AnzhuBeing)->void:
	striking.emit()
	who.was_just_struck(damage,weapon,self)

func was_just_struck(damage :int, weapon :String, who:AnzhuBeing)->void:
	if parse_incoming_damage(damage,weapon,who):
		process_character_strike()
		was_struck.emit()

###VIRTUALS####################################
func __physics_process(_delta:float)->void:pass
func parse_incoming_damage(_damage :int, _weapon :String, _who:AnzhuBeing)->bool: return true
func how_should_character_die()->void: pass
func character_signaler()->void: pass
func character_ready()->void: pass
func early_ready_for_debug()->void: pass
func character_process(_delta:float)->void:pass
func character_time_progressed(_current_time :DayNighton.TimeOfDay)->void: pass
func process_character_strike()->void:pass
func character_was_hit_over()->void: pass
###VIRTUALS####################################

@export_group('DEBUG')
@export var debug_all :bool = false
@export var debug_self :bool = false
var debug_icon :String
var debug_lambda :Callable = func(child :Node)->void:
	if child.has_method('debug'):
		child.debug()

func initialize_debugging()->void:
	if debug_self or debug_all:
		debug_self = true
	else:
		debug_lambda = func(_child :Node)->void:pass
	early_ready_for_debug()
	assertions()

func if_debug(message :String)->void:
	if debug_self:
		Debuggerton.dprint(message)

func assertions()->void:
	if debug_self:
		assert(made_loud_noise)
		assert(has_died)
		assert(on_new_track_tile)
		assert(hit_over)
		assert(striking)
		assert(was_struck)
		assert(direction_should_flip)
		assert(direction_changed)
		assert(direction_changed_named)
