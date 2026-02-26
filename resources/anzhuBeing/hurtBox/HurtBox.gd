@icon("res://resources/anzhuBeing/hurtBox/hurt_box.png")
class_name HurtBox extends Area2D #HurtBox.gd

@export_group("timer info")
enum AttackingDirection {Vertical, Horizontal, None}
var on_cooldown: bool = false
var current_attacking_direction :AttackingDirection = AttackingDirection.None

@onready var parent: AnzhuBeing = get_parent()
@onready var hurt_node: CollisionShape2D = $HurtShape
@onready var hurt_shape: RectangleShape2D = hurt_node.shape
@onready var hurt_timer: Timer = $Timer


func _ready():
	_signaler()
	__ready()


func _signaler():
	body_entered.connect(_on_body_entered)
	hurt_timer.timeout.connect(_end_attack_cooldown)
	__signaler()


func update_and_match_attacking_direction(incoming_direction: Vector2):
	if incoming_direction.y > 0 and current_attacking_direction != AttackingDirection.Vertical:
		current_attacking_direction = AttackingDirection.Vertical
		hurt_shape.size = Vector2(12.0,16.0)
	elif incoming_direction.x > 0 and current_attacking_direction != AttackingDirection.Horizontal:
		current_attacking_direction = AttackingDirection.Horizontal
		hurt_shape.size = Vector2(16.0,12.0)
	elif incoming_direction == Vector2.ZERO and current_attacking_direction != AttackingDirection.None:
		current_attacking_direction = AttackingDirection.None
		hurt_shape.size = Vector2(6.0,6.0)
	else:
		return


func _end_attack_cooldown():
	on_cooldown = false


func has_died():
	monitoring = false

# VIRTUALS
func _on_body_entered(_body: Node2D):
	pass
func __ready():
	pass
func __signaler():
	pass

# DEBUG
@export_category('DEBUG')
@export var debug_hurt_box: bool = false
