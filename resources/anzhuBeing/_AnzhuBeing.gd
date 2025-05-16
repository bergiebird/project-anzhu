class_name AnzhuBeing extends CharacterBody2D #_AnzhuBeing.gd
#region # Signals
signal publisher_null(method_name :String)
signal publisher_one(method_name :String, one :Variant)
signal publisher_two(method_name :String, one :Variant, two :Variant)
signal publisher_three(method_name :String, one :Variant, two :Variant, three :Variant)
#endregion
#region # Variables
enum PersonalDirection {NORTH,SOUTH,EAST,WEST}
var current_direction :int:
	set(value):
		if current_direction != value:
			current_direction = value
			var named_dir:String = Directon.get_current_direction(current_direction)
			publisher_one.emit('update_direction', Directon.get_personal_should_flip(named_dir))
			publisher_one.emit('direction_changed_with_value', current_direction)
			publisher_one.emit('direction_changed_with_name', named_dir)
var velocity_force :Vector2
var old_velocity_force :Vector2
const MAX_FORCE :Vector2 = Vector2(100,100)

enum AnimalType {Walrus, Owl, Human,  Bear, Fox, Hare, Wolf, Reindeer, Mammoth}

@export var this_animals_type :AnimalType
var personal_stats :Dictionary:
	set(value):
		personal_stats = value
		add_to_group(personal_stats["Group"])
		animal_icon = personal_stats["Icon"]
		move_speed = personal_stats["BaseMoveSpeed"]
		max_health = personal_stats["StartingHealth"]
var max_health :int
var move_speed :int:
	set(value):
		move_speed = value
		publisher_one.emit("move_speed_delivery", move_speed)
var animal_icon :String
var animal_name :String
var is_stunned :bool = false

## Lower than 0.08 reduces jitteryness, higher than makes it better at detecting walls.
@export var SAFE_MARGIN :float = 0.05
var is_sliding :bool = false:
	set(value): if value!=is_sliding:
		is_sliding = value
		publisher_one.emit("sliding", is_sliding)
var player :Player
#endregions
#region # Ready
func _ready():
	initialize_debugging()
	_setup_basics()
	_signaler()
	__ready()
	___ready()

func _setup_basics():
	add_to_group("being")
	set_motion_mode(MOTION_MODE_FLOATING)
	set_safe_margin(SAFE_MARGIN)
	personal_stats = Staton.CHARACTER_SHEET[this_animals_type]
	current_direction = PersonalDirection.EAST
	__setup_basics()
	___setup_basics()

func _signaler():
	Libraryton.player_reference.connect(get_player_reference)
	Signalton.loud_noise.connect(
		func(_who :AnzhuBeing, _where :Vector2, _noise_db :float):
			publisher_null.emit("loud_noise"))
	publisher_null.connect(func(func_name): Observerton.subscribe_null(self, func_name))
	publisher_one.connect(func(func_name, one): Observerton.subscribe_one(self, func_name, one))
	publisher_two.connect(func(func_name, one, two): Observerton.subscribe_two(self, func_name, one, two))
	publisher_three.connect(func(func_name, one, two, three): Observerton.subscribe_three(self, func_name, one, two, three))
	for child in get_children():
		publisher_null.connect(func(func_name): Observerton.subscribe_null(child, func_name))
		publisher_one.connect(func(func_name, one): Observerton.subscribe_one(child, func_name, one))
		publisher_two.connect(func(func_name, one, two): Observerton.subscribe_two(child, func_name, one, two))
		publisher_three.connect(func(func_name, one, two, three): Observerton.subscribe_three(child, func_name, one, two, three))
	__signaler()
	___signaler()

func get_player_reference(ref :Player):
	player = ref
	Libraryton.player_reference.disconnect(get_player_reference)

#endregion
#region # Process
func _process(delta:float):
	__process(delta)
	___process(delta)

func _physics_process(delta: float) -> void:
	__physics_process(delta)
	___physics_process(delta)
	if is_stunned:
		reset_velocities(true)
	else:
		apply_velocity_force(delta)
		if move_and_slide():
			pass

func parse_movement_vector(movement_vector :Vector2):
	if movement_vector == Vector2.ZERO:
		return
	movement_vector = movement_vector * move_speed
	if self is not Player:
		var abs_x = abs(movement_vector.x)
		var abs_y = abs(movement_vector.y)
		var new_direction: int
		if abs_y > abs_x:
			if movement_vector.y < 0:
				new_direction = PersonalDirection.NORTH
			else:
				new_direction = PersonalDirection.SOUTH
		else:
			if movement_vector.x > 0:
				new_direction = PersonalDirection.EAST
			else:
				new_direction = PersonalDirection.WEST
		if current_direction != new_direction:
			current_direction = new_direction
	velocity_force = movement_vector

func reset_velocities(all :bool=true):
	if all:
		velocity = Vector2.ZERO
		velocity_force = Vector2.ZERO
		old_velocity_force = Vector2.ZERO
		set_velocity(Vector2.ZERO)
	else:
		match current_direction:
			PersonalDirection.NORTH, PersonalDirection.SOUTH:
				velocity.x = 0
				velocity_force.x = 0
			PersonalDirection.EAST, PersonalDirection.WEST:
				velocity.y = 0
				velocity_force.y = 0

func apply_velocity_force(delta: float) -> void:
	if self is Player:
		velocity = velocity_force * delta
		old_velocity_force = velocity_force
		return
	if velocity_force != Vector2.ZERO:
		match current_direction:
			PersonalDirection.NORTH:
				velocity.y = -abs(velocity_force.y) * delta
				velocity.x = 0
			PersonalDirection.SOUTH:
				velocity.y = abs(velocity_force.y) * delta
				velocity.x = 0
			PersonalDirection.EAST:
				velocity.x = abs(velocity_force.x) * delta
				velocity.y = 0
			PersonalDirection.WEST:
				velocity.x = -abs(velocity_force.x) * delta
				velocity.y = 0
		old_velocity_force = velocity_force
	reset_velocities()

#endregion
#region # Functions
func strike_target(damage :int, weapon :String, who:AnzhuBeing):
	publisher_three.emit("_is_striking", damage, weapon, who)
	who._was_just_struck(damage,weapon,self)

func _was_just_struck(damage :int, weapon :String, who:AnzhuBeing):
	if parse_incoming_damage(damage,weapon,who):
		__was_just_struck(damage, weapon, who)
		___was_just_struck(damage, weapon, who)
		publisher_null.emit("was_struck")
#endregion

#region # Virtuals
func parse_incoming_damage(_damage :int, _weapon :String, _who:AnzhuBeing)->bool: return true
func how_should_character_die(): pass
func __setup_basics(): pass
func ___setup_basics(): pass
func __signaler(): pass
func ___signaler(): pass
func __ready(): pass
func ___ready(): pass
func early_ready_for_debug(): pass
func __process(_delta:float):pass
func ___process(_delta:float):pass
func __physics_process(_delta:float):pass
func ___physics_process(_delta:float):pass
func __time_progressed(_current_time :DayNighton.TimeOfDay): pass
func __was_just_struck(_damage :int, _weapon :String, _who:AnzhuBeing):pass
func ___was_just_struck(_damage :int, _weapon :String, _who:AnzhuBeing):pass
#endregion

#region # Debug
@export_group('DEBUG')
@export var debug_all :bool = false
@export var debug_self :bool = false
var debug_icon :String
var debug_lambda :Callable = func(child :Node):
	if child.has_method('debug'):
		child.debug()

func initialize_debugging():
	if debug_self or debug_all: debug_self = true
	else: debug_lambda = func(_child :Node):pass
	early_ready_for_debug()

func if_debug(message :String):
	if debug_self: Debuggerton.dprint(message)
#endregion
