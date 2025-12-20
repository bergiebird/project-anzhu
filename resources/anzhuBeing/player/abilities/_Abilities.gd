@icon("res://warehouse/icons/node/icon_human_controller.png")

class_name Abilities
extends Node2D

# TODO: Make the spacebar the modifier so you can reduce the inputs of the blayer.
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
var is_efficient: bool=false

@onready var old_state: AbilityStates = AbilityStates.NONE:
	set(v):
		old_state = v
		match old_state:
			AbilityStates.NONE:
				pass
			AbilityStates.IDLING:
				pass
			AbilityStates.MOVING:
				pass
			AbilityStates.JUMPING:
				pass
#				parent.publish_event.emit('jumping', false)
			AbilityStates.RELOADING:
				parent.publish_event.emit('reloading', false)
				parent.publish_event.emit('full_ammo',true)
			AbilityStates.INIT_JUMP:
				parent.publish_event.emit('initializing_jump', false)
			AbilityStates.GUNFIRED:
				pass
@onready var current_state: int = AbilityStates.NONE:
	set(v): if v != current_state:
		old_state = current_state
		current_state = v
		match current_state:
			AbilityStates.NONE:
				pass
			AbilityStates.IDLING:
				pass
			AbilityStates.MOVING:
				pass
			AbilityStates.JUMPING:
				pass
#				parent.publish_event.emit('jumping', true)
			AbilityStates.RELOADING:
				parent.publish_event.emit('reloading', true)
			AbilityStates.INIT_JUMP:
				parent.publish_event.emit('initializing_jump', true)
			AbilityStates.GUNFIRED:
				current_state = AbilityStates.IDLING


func _ready():
	parent = get_parent()
	for child in get_children():
		child.set_physics_process(true)
		child.set_process(true)
	current_state =AbilityStates.IDLING


#region   #=======================================================# DEBUG
@export_group('Debug')
@export var debug_abilities: bool = false
@export var debugger_color: Color = Color("eaf1f0")
@onready var dcolor: String = debugger_color.to_html()

func debug():
	Dbgr.enable_print(self.name, dcolor)
	debug_abilities = true

func if_debug(message :String):
	if debug_abilities:
		Dbgr.dprint(message, dcolor)
#endregion
