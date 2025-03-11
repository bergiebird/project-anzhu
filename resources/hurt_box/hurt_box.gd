extends Area2D #HurtBox.gd
@onready var hurt_shape :CollisionShape2D = $HurtShape
@export var hurt_cooldown :float = 2.0
var parent
var on_cooldown :bool = false
var current_attacking_direction :AttackingDirection = AttackingDirection.None
var audio :Node2D
enum AttackingDirection {Vertical, Horizontal, None}
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		audio = node_dictionary['AudioManager']
		parent = node_dictionary['parent']


func update_and_match_attacking_direction(incoming_direction :Vector2)->void:
	if incoming_direction.y > 0 and current_attacking_direction != AttackingDirection.Vertical:
		current_attacking_direction = AttackingDirection.Vertical
	elif incoming_direction.x > 0 and current_attacking_direction != AttackingDirection.Horizontal:
		current_attacking_direction = AttackingDirection.Horizontal
	elif incoming_direction == Vector2.ZERO and current_attacking_direction != AttackingDirection.None:
		current_attacking_direction = AttackingDirection.None
	else:
		return
	match current_attacking_direction:
		AttackingDirection.Horizontal:
			hurt_shape.shape.size = Vector2(16.0,8.0)
		AttackingDirection.Vertical:
			hurt_shape.shape.size = Vector2(8.0,16.0)
		AttackingDirection.None:
			hurt_shape.shape.size = Vector2(6.0,6.0)

func _on_body_entered(body: Node2D) -> void:
	if on_cooldown:
		return
	audio.start_sfx('Chomp')
	on_cooldown = true
	Signalton.player_hit.emit()
	await get_tree().create_timer(hurt_cooldown).timeout
	on_cooldown = false

func disable_hurt_box(unused_string :String)->void:
	monitoring = false
