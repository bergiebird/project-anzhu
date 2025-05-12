class_name AnzhuBeing extends CharacterBody2D #_AnzhuBeing.gd

signal observer_null(method_name :String)
signal observer_one(method_name :String, one :Variant)
signal observer_two(method_name :String, one :Variant, two :Variant)
signal observer_three(method_name :String, one :Variant, two :Variant, three :Variant)

signal tell_self_is_striking (attacking_who :AnzhuBeing, who_is_attacking :AnzhuBeing, what_weapon :Variant)
signal was_struck

enum PersonalDirection {NORTH,SOUTH,EAST,WEST}
var current_direction :int:
	set(value):
		if current_direction != value:
			current_direction = value
			var named_direction:String = Directon.get_current_direction(current_direction)
			observer_one.emit('direction_flipped', Directon.get_personal_should_flip(named_direction))
			observer_one.emit('direction_changed_with_value', current_direction)
			observer_one.emit('direction_changed_with_name', named_direction)
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
@onready var mask :Mask = $Mask

#region #READY
func _ready()->void:
	initialize_debugging()
	setup_basics()
	_signaler()
	__ready()
	___ready()

func setup_basics()->void:
	add_to_group("being")
	set_motion_mode(MOTION_MODE_FLOATING)
	set_safe_margin(NEW_SAFE_MARGIN)
	animal_name = ANIMAL_NAMES[this_animals_type]
	current_direction = PersonalDirection.EAST
	for child in get_children():
		if child.has_method('being_process'):         being_process_array.append(child)
		if child.has_method('being_physics_process'): being_physics_process_array.append(child)

func _signaler()->void:
	DayNighton.time_dictionary_delivery.connect(get_daynight_dictionary) # One time signal
	DayNighton.time_progressed.connect(_time_progressed)                 # Unused, for future usage
	Libraryton.player_reference.connect(get_player_reference)            # One time signal
	observer_null.connect(func(func_name): Observerton.match_null(self, func_name))
	observer_one.connect(func(func_name, one): Observerton.match_one(self, func_name, one))
	observer_two.connect(func(func_name, one, two): Observerton.match_two(self, func_name, one, two))
	observer_three.connect(func(func_name, one, two, three): Observerton.match_three(self, func_name, one, two, three))
	mask.has_died.connect(how_should_character_die)
	__signaler()
	___signaler()

func get_player_reference(ref :Player)->void:
	player = ref
	Libraryton.player_reference.disconnect(get_player_reference)

func get_daynight_dictionary(delivery :Dictionary)->void:
	daynight_dictionary = delivery
	DayNighton.time_dictionary_delivery.disconnect(get_daynight_dictionary)

#region #PROCESS
func _process(delta:float)->void:
	__process(delta)
	___process(delta)
	for being:Node in being_process_array:
		being.being_process(delta)


func _physics_process(delta: float) -> void:
	__physics_process(delta)
	___physics_process(delta)
	for being:Node in being_physics_process_array:
		being.being_physics_process(delta)
	velocity_force_filter_for_direction(delta)
	if move_and_slide():
		pass

func velocity_force_filter_for_direction(delta:float)->void:
	if self is not Player:
		if velocity_force != Vector2.ZERO:
			var new_direction :int = Directon.get_prevalent_direction(velocity_force)
			if current_direction != new_direction:
				current_direction = new_direction
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
#endregion

#region #Functions
func _time_progressed(current_time :DayNighton.TimeOfDay)->void:
	if debug_self: print_rich('[color=eaf1f0] Time has progressed')
	__time_progressed(current_time)

func strike_target(damage :int, weapon :String, who:AnzhuBeing)->void:
	tell_self_is_striking.emit()
	who._was_just_struck(damage,weapon,self)

func _was_just_struck(damage :int, weapon :String, who:AnzhuBeing)->void:
	if parse_incoming_damage(damage,weapon,who):
		_was_just_struck(damage, weapon, who)
		__was_just_struck(damage, weapon, who)
		observer_null.emit("was_struck")
#endregion


#region # VIRTUALS
func parse_incoming_damage(_damage :int, _weapon :String, _who:AnzhuBeing)->bool: return true
func how_should_character_die()->void: pass
func __signaler()->void: pass
func ___signaler()->void: pass
func __ready()->void: pass
func ___ready()->void: pass
func early_ready_for_debug()->void: pass
func __process(_delta:float)->void:pass
func ___process(_delta:float)->void:pass
func __physics_process(_delta:float)->void:pass
func ___physics_process(_delta:float)->void:pass
func __time_progressed(_current_time :DayNighton.TimeOfDay)->void: pass
func __was_just_struck(_damage :int, _weapon :String, _who:AnzhuBeing)->void:pass
func ___was_just_struck(_damage :int, _weapon :String, _who:AnzhuBeing)->void:pass
func character_was_hit_over()->void: pass
#endregion

#region Debug
@export_group('DEBUG')
@export var debug_all :bool = false
@export var debug_self :bool = false
var debug_icon :String
var debug_lambda :Callable = func(child :Node)->void:
	if child.has_method('debug'):
		child.debug()

func initialize_debugging()->void:
	if debug_self or debug_all: debug_self = true
	else: debug_lambda = func(_child :Node)->void:pass
	early_ready_for_debug()

func if_debug(message :String)->void:
	if debug_self: Debuggerton.dprint(message)
#endregion
