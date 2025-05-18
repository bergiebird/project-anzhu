@icon("res://warehouse/icons/node/icon_human_controller.png")
class_name Abilities extends Node2D
@export var shoot_cooldown :float = 0.4
enum AbilityStates {NONE, IDLING, MOVING, INIT_JUMP, JUMPING, RELOADING, GUNFIRED,}

@onready var old_state :AbilityStates = AbilityStates.NONE:
	set(value):
		old_state = value
		match old_state:
			AbilityStates.NONE:
				pass
			AbilityStates.IDLING:
				pass
			AbilityStates.MOVING:
				parent.publisher_one.emit("reset_velocities", true)
			AbilityStates.JUMPING:
				parent.publisher_one.emit('jumping', false)
			AbilityStates.RELOADING:
				parent.publisher_one.emit('reloading', false)
				parent.publisher_one.emit('full_ammo', true)
			AbilityStates.INIT_JUMP:
				parent.publisher_one.emit('initializing_jump', false)
			AbilityStates.GUNFIRED:
				pass

@onready var current_state :int = AbilityStates.NONE:
	set(value): if value != current_state:
		old_state = current_state
		current_state = value
		match current_state:
			AbilityStates.NONE:
				pass
			AbilityStates.IDLING:
				pass
			AbilityStates.MOVING:
				pass
			AbilityStates.JUMPING:
				parent.publisher_one.emit('jumping', true)
			AbilityStates.RELOADING:
				parent.publisher_one.emit('reloading', true)
			AbilityStates.INIT_JUMP:
				parent.publisher_one.emit('initializing_jump', true)
			AbilityStates.GUNFIRED:
				current_state = AbilityStates.IDLING


var is_efficient :bool=false:
	set(value):
			is_efficient = value
			if_debug('is_efficient: '+ str(is_efficient))
			parent.publisher_one.emit('efficiency', is_efficient)

var parent :Player

func _ready()->void:
	parent = get_parent()
	for child :Ability in get_children():
		child.parent = self
		child.grandparent = parent
		child.set_physics_process(true)
	current_state =AbilityStates.IDLING

#region #DEBUG
###
@export_group('Debug')
@export var debug_abilities :bool = false
@export var debugger_color :Color = Color("eaf1f0")
@onready var dcolor :String = debugger_color.to_html()

func debug()->void:
	Debuggerton.enable_print(self.name, dcolor)
	debug_abilities = true

func if_debug(message :String)->void:
	if debug_abilities:
		Debuggerton.dprint(message, dcolor)
#endregion
