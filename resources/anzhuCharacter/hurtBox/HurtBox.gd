@icon("res://resources/anzhuCharacter/hurtBox/hurt_box.png")
extends Area2D #HurtBox.gd
enum AttackingDirection {Vertical, Horizontal, None}
@export_category('DEBUG')
@export var debug_hurt_box :bool = false
var on_cooldown :bool = false
var current_attacking_direction :AttackingDirection = AttackingDirection.None
@onready var parent :AnzhuCharacter = get_parent()
@onready var hurt_shape :CollisionShape2D = $HurtShape
@onready var timer :Timer = $Timer

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timeout)

func update_and_match_attacking_direction(incoming_direction :Vector2)->void:
	if incoming_direction.y > 0 and current_attacking_direction != AttackingDirection.Vertical:         
		current_attacking_direction = AttackingDirection.Vertical
		hurt_shape.shape.size = Vector2(8.0,16.0)
	elif incoming_direction.x > 0 and current_attacking_direction != AttackingDirection.Horizontal:     
		current_attacking_direction = AttackingDirection.Horizontal
		hurt_shape.shape.size = Vector2(16.0,8.0)
	elif incoming_direction == Vector2.ZERO and current_attacking_direction != AttackingDirection.None: 
		current_attacking_direction = AttackingDirection.None
		hurt_shape.shape.size = Vector2(6.0,6.0)
	else: 
		return    

func _on_body_entered(body :Node2D)->void:
	if not on_cooldown: 
		parent.striking.emit()
		on_cooldown = true
		timer.start()

func _on_timeout()->void: 
	on_cooldown = false

func _physics_process(delta :float)->void:
	update_and_match_attacking_direction(abs(parent.get_real_velocity()))
