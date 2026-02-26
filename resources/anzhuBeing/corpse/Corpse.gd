@icon("res://resources/anzhuBeing/corpse/icon_bag.png")
class_name Corpse extends Area2D

var stored_position: Vector2
var is_dead: bool
@onready var parent: AnzhuBeing = get_parent()
@onready var mask: CollisionShape2D = parent.get_node('Mask')

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	Sgnl.sfx_requested.emit()
	if body is Player and is_dead:
		queue_free()

func has_died():
	is_dead = true
	await _has_died()
	reparent_at_same_location()
	construct_new_animation()
	be_free()

func reparent_at_same_location():
	stored_position = parent.global_position
	var new_parent = parent.get_parent()
	parent.remove_child(self)
	new_parent.add_child(self)
	global_position = stored_position

func construct_new_animation():
	var new_anim :AnimatedSprite2D = AnimatedSprite2D.new()
	var old_anims :AnimatedSprite2D = parent.get_node('Animations')
	new_anim.sprite_frames = old_anims.sprite_frames
	new_anim.animation = "Corpse"
	new_anim.z_index = 1
	add_child(new_anim)

func be_free():

	if has_node("CollisionShape2D"):
		$CollisionShape2D.queue_free()
	if mask.get_parent() == parent:
		parent.remove_child(mask)
	if mask.get_parent() != self:
		add_child(mask)
	monitorable = true
	monitoring = true
	z_index = 3
	parent.queue_free()

#region Virtuals
func _has_died():pass
#endregion
#region DEBUG
@export_group('DEBUG')
@export var debug_corpse: bool = false

func debug():
	debug_corpse = true
#endregion
