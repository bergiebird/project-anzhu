class_name AnzhuBeing extends CharacterBody2D
#region    #============================================================# Signals
signal publisher_null(method_name :String)
signal publisher_one(method_name :String, one :Variant)
signal publisher_two(method_name :String, one :Variant, two :Variant)
signal publisher_three(method_name :String, one :Variant, two :Variant, three :Variant)
#endregion #============================================================# Signals
#region    #============================================================# Variables
enum PersonalDirection {NORTH,SOUTH,EAST,WEST}
enum SpeedType{CREEP,WALK,JOG,RUN}
@export var this_animals_type :AnimalType
var current_direction :int:
	set(value):
		if current_direction != value:
			current_direction = value
			var named_dir:String = Directon.get_current_direction(current_direction)
			publisher_one.emit('update_direction', Directon.get_personal_should_flip(named_dir))
			publisher_one.emit('direction_changed_with_value', current_direction)
			publisher_one.emit('direction_changed_with_name', named_dir)
var speed_types :Dictionary
enum AnimalType {Walrus, Owl, Human,  Bear, Fox, Hare, Wolf, Reindeer, Mammoth}
var personal_stats :Dictionary:
	set(value):
		personal_stats = value
		add_to_group(personal_stats["Group"])
		animal_icon = personal_stats["Icon"]
		max_health = personal_stats["StartingHealth"]
		speed_types = personal_stats["SpeedType"]
var max_health :int
var animal_icon :String
var animal_name :String
var velocity_force :Vector2
var is_stunned :bool = false
var player :Player
@export var SAFE_MARGIN :float = 0.05 ## Lower than 0.08 reduces jitteryness, higher than makes it better at detecting walls.
var is_sliding :bool = false:
	set(value): if value!=is_sliding:
		is_sliding = value
		publisher_one.emit("sliding", is_sliding)

#endregion #============================================================# Variables
#region    #============================================================# Ready
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
	Libraryton.player_reference.connect(player_ref)
	Signalton.loud_noise.connect(func(_who :AnzhuBeing, _where :Vector2, _db :float): publisher_null.emit("loud_noise"))
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

func player_ref(ref :Player):
	player = ref
	Libraryton.player_reference.disconnect(player_ref)
#endregion #============================================================# Ready
#region    #============================================================# Movement
func _process(delta:float):
	__process(delta)
	___process(delta)

func _physics_process(delta: float) -> void:
	__physics_process(delta)
	___physics_process(delta)
	velocity = velocity_force * delta
	move_and_slide()
	if not is_sliding:
		velocity_force = Vector2.ZERO
		velocity /= 0.1

#endregion #============================================================# Movement
#region    #============================================================# Strikes
func strike_target(damage :int, weapon :String, who:AnzhuBeing):
	publisher_three.emit("_is_striking", damage, weapon, who)
	who._was_just_struck(damage,weapon,self)

func _was_just_struck(damage :int, weapon :String, who:AnzhuBeing):
	if parse_incoming_damage(damage,weapon,who):
		__was_just_struck(damage, weapon, who)
		___was_just_struck(damage, weapon, who)
		publisher_null.emit("was_struck")

#endregion #============================================================# Strikes
#region    #============================================================# VIRTUALS
func parse_incoming_damage(_damage :int, _weapon :String, _who:AnzhuBeing)->bool: return true
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
func __was_just_struck(_damage :int, _weapon :String, _who:AnzhuBeing):pass
func ___was_just_struck(_damage :int, _weapon :String, _who:AnzhuBeing):pass
#endregion #============================================================# VIRTUALS
#region    #============================================================# Debug
@export_group('DEBUG')
@export var debug_all :bool = false
@export var debug_self :bool = false
var debug_icon :String

func initialize_debugging():
	if debug_self or debug_all: debug_self = true
	early_ready_for_debug()

func if_debug(message :String):
	if debug_self: Debuggerton.dprint(message)
#endregion #============================================================# Debug
