@icon("res://resources/AnzhuBeing/hurtBox/hurt_box.png")
class_name HurtBox extends Area2D #HurtBox.gd
@export_group("timer info")
@export var wait_time :float = 2.0
enum AttackingDirection {Vertical, Horizontal, None}
var on_cooldown :bool = false
var current_attacking_direction :AttackingDirection = AttackingDirection.None
@onready var parent :AnzhuBeing = get_parent()
@onready var hurt_node :CollisionShape2D = $HurtShape
@onready var hurt_shape :RectangleShape2D = hurt_node.shape
@onready var hurt_timer :Timer = Timer.new()

func _ready() -> void:
	_init_nodes()
	_signal_connector()
	ready()

func _init_nodes()->void:
	hurt_timer.wait_time = wait_time

func _signal_connector()->void:
	body_entered.connect(on_body_entered)
	hurt_timer.timeout.connect(end_attack_cooldown)
	signal_connector()

func update_and_match_attacking_direction(incoming_direction :Vector2)->void:
	if incoming_direction.y > 0 and current_attacking_direction != AttackingDirection.Vertical:
		current_attacking_direction = AttackingDirection.Vertical
		hurt_shape.size = Vector2(8.0,16.0)
	elif incoming_direction.x > 0 and current_attacking_direction != AttackingDirection.Horizontal:
		current_attacking_direction = AttackingDirection.Horizontal
		hurt_shape.size = Vector2(16.0,8.0)
	elif incoming_direction == Vector2.ZERO and current_attacking_direction != AttackingDirection.None:
		current_attacking_direction = AttackingDirection.None
		hurt_shape.size = Vector2(6.0,6.0)
	else:
		return

func end_attack_cooldown()->void:
	on_cooldown = false

###
## Virtuals
func on_body_entered(_body :AnzhuBeing)->void:pass
func ready()->void:pass
func signal_connector()->void:pass
###
##DEBUG
###
@export_category('DEBUG')
@export var debug_hurt_box :bool = false
