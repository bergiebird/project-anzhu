@icon("res://resources/anzhuCharacter/corpse/icon_bag.png")
extends Area2D #Corpse.gd
@export var is_edible :bool = false
@export var is_meat :bool = false
@export var energy :int = 1
@export_category('DEBUG')
@export var debug_corpse :bool = false
var parent :AnzhuCharacter
var grandparent :Node
var anim :AnimatedSprite2D
var mask :CollisionShape2D
var stored_position :Vector2
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
		parent = node_dictionary['scene_root']
		grandparent = parent.get_parent()
		anim = node_dictionary['Animations']
		mask = node_dictionary['Mask']

func _ready()->void:
	connect('body_entered', _on_body_entered)

func allow_pickup()->void:
	monitorable = true
	monitoring = true

func end_of_life(unused_variable)->void:
	var new_anim :AnimatedSprite2D = AnimatedSprite2D.new()
	stored_position = parent.global_position
	new_anim.sprite_frames = anim.sprite_frames
	new_anim.animation = "Corpse"
	new_anim.z_index = 1
	#new_anim.modulate = Color("b74132")
	parent.remove_child(self)
	grandparent.add_child(self)
	self.global_position = stored_position
	add_child(new_anim)
	parent.remove_child(mask)
	add_child(mask)
	allow_pickup()
	parent.queue_free()


func _on_body_entered(body :Node2D)->void:
	queue_free()

func debug()->void:
	debug_corpse = true
