@icon("res://warehouse/icons/node/icon_human_controller.png")

class_name Abilities
extends Node2D

# TODO: Make the spacebar the modifier so you can reduce the inputs of the player.
enum AbilityStates {
	NONE,
	IDLING,
	MOVING,
	INIT_JUMP,
	JUMPING,
	RELOADING,
	GUNFIRED, ##
	CROUCHING, ## Spacebar, this is the modifier
	}

@export var shoot_cooldown: float = 0.4

var parent: Player
var is_efficient: bool = false

@onready var gun: Gunshot = $Gun

@onready var old_state: AbilityStates = AbilityStates.NONE:
	set(v):
		old_state = v
		match old_state:
			AbilityStates.INIT_JUMP:
				parent.publish_event.emit('initializing_jump', false)

@onready var current_state: int = AbilityStates.NONE:
	set(v): if v != current_state:
		old_state = current_state
		current_state = v
		match current_state:
			AbilityStates.GUNFIRED:
				current_state = AbilityStates.IDLING


func _ready() -> void:
	parent = get_parent()
	for child in get_children():
		child.set_physics_process(true)
		child.set_process(true)
	current_state =AbilityStates.IDLING


func _on_reload_animation_reloading_ended() -> void:
	current_state = AbilityStates.IDLING
	gun.has_ammo = true
