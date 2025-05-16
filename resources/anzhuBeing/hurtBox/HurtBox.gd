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
	_signaler()
	__ready()

func _init_nodes()->void:
	hurt_timer.wait_time = wait_time

func _signaler()->void:
	body_entered.connect(_on_body_entered)
	hurt_timer.timeout.connect(_end_attack_cooldown)
	__signaler()

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

func _end_attack_cooldown()->void:
	on_cooldown = false

func set_hurtbox_monitoring(_is_monitoring :bool):
	monitoring = _is_monitoring

func has_died():
	set_hurtbox_monitoring(false)

#region # Virtuals
func _on_body_entered(_body :AnzhuBeing)->void:pass
func __ready()->void:pass
func __signaler()->void:pass
#endregion
#region #DEBUG
@export_category('DEBUG')
@export var debug_hurt_box :bool = false
#endregion
