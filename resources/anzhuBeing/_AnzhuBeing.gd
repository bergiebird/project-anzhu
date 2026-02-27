extends CharacterBody2D
class_name AnzhuBeing

signal publish_event(String, Variant)

enum PersonalDirection {NORTH,SOUTH,EAST,WEST}
enum SpeedType {CREEP,WALK,JOG,RUN}
## Used for setting the group & stats
@export_enum("Walrus", "Owl", "Human",  "Bear", "Fox", "Hare", "Wolf", "Deer", "Mammoth") var this_beings_type: String
@export_multiline var visual_description: String = ""
## Lower than 0.08 reduces jitteryness, higher than makes it better at detecting walls.
@export var SAFE_MARGIN: float = 0.05

var current_direction: int:
	set(value):
		if current_direction != value:
			current_direction = value
			var named_dir: String = Directon.get_current_direction(current_direction)
			publish_event.emit('update_direction',
			{
				"Name": named_dir,
				"Flip": Directon.get_personal_should_flip(named_dir),
				})

var personal_stats: Dictionary:
	set(value):
		personal_stats = value
		add_to_group("being")
		add_to_group(this_beings_type)
		entity_icon = personal_stats["Icon"]
		max_health = personal_stats["StartingHealth"]
		speed_types = personal_stats["SpeedType"]
var max_health: int
var speed_types: Dictionary
var entity_icon: String
var velocity_force: Vector2
var is_on_ice: bool = false

var is_sliding: bool = false:
	set(value): if value!=is_sliding:
		is_sliding = value
		publish_event.emit("sliding", is_sliding)


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
	personal_stats = Lib.Beings.INFO[this_beings_type]
	current_direction = PersonalDirection.EAST
	__setup_basics()
	___setup_basics()

func _signaler():
	Sgnl.player_reference.connect(player_reference_subscriber)
	publish_event.connect(
		func(func_name:String, data: Variant = null) -> void:
			Lib.Observe.subscribe_to_event(self, func_name, data))
	for child: Node in get_children():
		publish_event.connect(
			func(func_name:String, data: Variant = null) -> void:
				Lib.Observe.subscribe_to_event(child, func_name, data))
	__signaler()
	___signaler()

var player: Player
func player_reference_subscriber(ref: Player):
	player = ref
	Sgnl.player_reference.disconnect(player_reference_subscriber)

#endregion #============================================================# Ready
#region    #============================================================# Movement

func _process(delta:float) -> void:
	__process(delta)
	___process(delta)


func _physics_process(delta: float) -> void:
	__physics_process(delta)
	___physics_process(delta)
	velocity = velocity_force * delta
	move_and_slide()
	if not is_sliding:
		velocity_force = Vector2.ZERO
		velocity /= 0.05

#endregion #============================================================# Movement
#region    #============================================================# Strikes

func strike_target(attack: Attack):
	attack.victim._was_just_struck(attack)

func _was_just_struck(attack: Attack):
	if parse_incoming_damage(attack):
		__was_just_struck(attack)
		___was_just_struck(attack)
		publish_event.emit("was_struck")

#endregion #============================================================# Strikes
#region    #============================================================# MISC

func collide_with_(layer: int, is_enabled: bool):
	set_collision_layer_value(layer, is_enabled)
	set_collision_mask_value(layer, is_enabled)

#endregion #============================================================# MISC
#region    #============================================================# VIRTUALS

func parse_incoming_damage(_attack: Attack)->bool: return true
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
func __was_just_struck(_attack :Attack):pass
func ___was_just_struck(_attack :Attack):pass

#endregion #============================================================# VIRTUALS
#region    #============================================================# Debug

@export_group('DEBUG')
@export var debug_all: bool = false
@export var debug_self: bool = false
var debug_icon: String

func initialize_debugging():
	if debug_self or debug_all: debug_self = true
	early_ready_for_debug()

func if_debug(message: String):
	if debug_self:
		Dbgr.dprint(message)
#endregion #============================================================# Debug
