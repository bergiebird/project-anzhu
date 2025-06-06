extends CharacterBody2D
class_name AnzhuBeing

#region    #============================================================# Signals

signal publish_event(String, Variant)

#endregion #============================================================# Signals
#region    #============================================================# Variables

enum PersonalDirection {NORTH,SOUTH,EAST,WEST}
enum SpeedType {CREEP,WALK,JOG,RUN}
## Used for setting the group & stats
@export_enum("Walrus", "Owl", "Human",  "Bear", "Fox", "Hare", "Wolf", "Deer", "Mammoth") var this_beings_type :String
@export_multiline var visual_description :String = ""
## Lower than 0.08 reduces jitteryness, higher than makes it better at detecting walls.
@export var SAFE_MARGIN :float = 0.05

var current_direction :int:
	set(value):
		if current_direction != value:
			current_direction = value
			var named_dir :String = Directon.get_current_direction(current_direction)
			publish_event.emit('update_direction',
			{
				"Name": named_dir,
				"Flip": Directon.get_personal_should_flip(named_dir),
				})

var personal_stats :Dictionary:
	set(value):
		personal_stats = value
		add_to_group("being")
		add_to_group(this_beings_type)
		entity_icon = personal_stats["Icon"]
		max_health = personal_stats["StartingHealth"]
		speed_types = personal_stats["SpeedType"]
var max_health :int
var speed_types :Dictionary
var entity_icon :String
var velocity_force :Vector2

var is_sliding :bool = false:
	set(value): if value!=is_sliding:
		is_sliding = value
		publish_event.emit("sliding", is_sliding)

#endregion #============================================================# Variables
#region    #============================================================# Ready

func _ready():
	initialize_debugging()
	_setup_basics()
	_signaler()
	__ready()
	___ready()

func _setup_basics():
	set_motion_mode(MOTION_MODE_FLOATING)
	set_safe_margin(SAFE_MARGIN)
	personal_stats =L.Beings.INFO[this_beings_type]
	current_direction = PersonalDirection.EAST
	z_index = 3
	__setup_basics()
	___setup_basics()

func _signaler():
	Signalton.player_reference.connect(player_reference_subscriber)
	publish_event.connect(func(func_name:String, data:Variant=null):L.Observe.subscribe_to_event(self, func_name, data))
	for child in get_children():
		publish_event.connect(func(func_name:String, data:Variant=null):L.Observe.subscribe_to_event(child, func_name, data))
	__signaler()
	___signaler()

var player :Player
func player_reference_subscriber(ref :Player):
	player = ref
	Signalton.player_reference.disconnect(player_reference_subscriber)

#endregion #============================================================# Ready
#region    #============================================================# Movement

func _process(delta:float):
	__process(delta)
	___process(delta)

func _physics_process(delta: float):
	__physics_process(delta)
	___physics_process(delta)
	velocity = velocity_force * delta
	move_and_slide()
	if not is_sliding:
		velocity_force = Vector2.ZERO
		velocity /= 0.1

#endregion #============================================================# Movement
#region    #============================================================# Strikes

func strike_target(attack :Dictionary):
	attack["VICTIM"]._was_just_struck(attack)

func _was_just_struck(attack :Dictionary):
	if parse_incoming_damage(attack):
		__was_just_struck(attack)
		___was_just_struck(attack)
		publish_event.emit("was_struck")

#endregion #============================================================# Strikes
#region    #============================================================# MISC

func collide_with_(layer :int, is_enabled :bool):
	set_collision_layer_value(layer, is_enabled)
	set_collision_mask_value(layer, is_enabled)

#endregion #============================================================# MISC
#region    #============================================================# VIRTUALS

func parse_incoming_damage(_attack :Dictionary)->bool: return true
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
func __was_just_struck(_attack :Dictionary):pass
func ___was_just_struck(_attack :Dictionary):pass

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
