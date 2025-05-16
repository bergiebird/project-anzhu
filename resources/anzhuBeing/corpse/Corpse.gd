@icon("res://resources/AnzhuBeing/corpse/icon_bag.png")
class_name Corpse extends Area2D #Corpse.gd
var stored_position :Vector2
@onready var parent :AnzhuBeing = get_parent()
@onready var mask :CollisionShape2D = parent.get_node('Mask')

func _ready()->void:
	body_entered.connect(_on_body_entered)
	parent.publisher_null.connect(func(func_name): Observerton.subscribe_null(self, func_name))

func _on_body_entered(_body :Node2D)->void:
	queue_free()

func end_of_life()->void:
	_end_of_life()
	reparent_at_same_location()
	construct_new_animation()
	be_free()

func reparent_at_same_location()->void:
	stored_position = parent.global_position
	parent.remove_child(self)
	parent.get_parent().add_child(self)
	self.global_position = stored_position

func construct_new_animation()->void:
	var new_anim :AnimatedSprite2D = AnimatedSprite2D.new()
	var old_anims :AnimatedSprite2D = parent.get_node('Animations')
	new_anim.sprite_frames = old_anims.sprite_frames
	new_anim.animation = "Corpse"
	new_anim.z_index = 1
	add_child(new_anim)

func be_free()->void:
	if has_node("CollisionShape2D"):
		$CollisionShape2D.queue_free()
	parent.remove_child(mask)
	add_child(mask)
	monitorable = true
	monitoring = true
	parent.queue_free()

#region Virtuals
func _end_of_life()->void:pass
#endregion

#region DEBUG
@export_group('DEBUG')
@export var debug_corpse :bool = false

func debug()->void:
	debug_corpse = true
#endregion
