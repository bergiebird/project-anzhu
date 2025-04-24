@icon("res://resources/AnzhuBeing/corpse/icon_bag.png")
class_name Corpse extends Area2D #Corpse.gd
@export_group('info')
@export var is_edible :bool = false
@export var is_meat :bool = false
@export var energy :int = 1
var stored_position :Vector2
@onready var temp_shape :CollisionShape2D = $OnlyHereToBeDestroyed
@onready var parent :AnzhuBeing = get_parent()
@onready var grandparent :Node = parent.get_parent()
@onready var anim :AnimatedSprite2D = parent.get_node('Animations')
@onready var mask :CollisionShape2D = parent.get_node('Mask')

func _ready()->void:
	connect('body_entered', _on_body_entered)

func allow_pickup()->void:
	monitorable = true
	monitoring = true

func _on_body_entered(body :Node2D)->void:
	queue_free()

###
## EOL
###
func end_of_life()->void:
	reparent_at_same_location()
	construct_new_animation()
	be_free()

func reparent_at_same_location()->void:
	stored_position = parent.global_position
	parent.remove_child(self)
	grandparent.add_child(self)
	self.global_position = stored_position

func construct_new_animation()->void:
	var new_anim :AnimatedSprite2D = AnimatedSprite2D.new()
	new_anim.sprite_frames = anim.sprite_frames
	new_anim.animation = "Corpse"
	new_anim.z_index = 1
	add_child(new_anim)

func be_free()->void:
	temp_shape.queue_free()
	parent.remove_child(mask)
	add_child(mask)
	allow_pickup()
	parent.queue_free()

###
## DEBUG
###
@export_group('DEBUG')
@export var debug_corpse :bool = false

func debug()->void:
	debug_corpse = true
