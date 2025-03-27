@icon("res://resources/anzhuCharacter/hurtBox/hurt_box.png")
extends Area2D #HurtBox.gd
signal has_striked(attack :String)
@export_category('DEBUG')
@export var debug_hurt_box :bool = false
var parent
var on_cooldown :bool = false
var current_attacking_direction :AttackingDirection = AttackingDirection.None
var audio :Node2D
@onready var hurt_shape :CollisionShape2D = $HurtShape
@onready var S :Signalton = Signalton
@onready var timer :Timer = $Timer
enum AttackingDirection {Vertical, Horizontal, None}
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		audio = node_dictionary['AudioManager']
		parent = node_dictionary['scene_root']

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func update_and_match_attacking_direction(incoming_direction :Vector2)->void:
	if incoming_direction.y > 0 and current_attacking_direction != AttackingDirection.Vertical:         current_attacking_direction = AttackingDirection.Vertical
	elif incoming_direction.x > 0 and current_attacking_direction != AttackingDirection.Horizontal:     current_attacking_direction = AttackingDirection.Horizontal
	elif incoming_direction == Vector2.ZERO and current_attacking_direction != AttackingDirection.None: current_attacking_direction = AttackingDirection.None
	else: return
	match current_attacking_direction:
		AttackingDirection.Horizontal: hurt_shape.shape.size = Vector2(16.0,8.0)
		AttackingDirection.Vertical:   hurt_shape.shape.size = Vector2(8.0,16.0)
		AttackingDirection.None:       hurt_shape.shape.size = Vector2(6.0,6.0)

func _on_body_entered(body: Node2D) -> void:
	if on_cooldown: return
	has_striked.emit("Strike")
	on_cooldown = true
	S.player_hit.emit()
	timer.start()

func _on_timer_hurt_timeout() -> void: on_cooldown = false

func _physics_process(delta: float) -> void:
	update_and_match_attacking_direction(abs(parent.get_real_velocity()))
