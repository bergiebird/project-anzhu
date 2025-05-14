@icon("res://warehouse/_icons/node/icon_human_controller.png")
class_name Abilities extends Node2D #PlayerAbilities.gd

@export var shoot_cooldown :float = 0.4
enum AbilityStates {NONE, IDLING, MOVING, INIT_JUMP, JUMPING, RELOADING, GUNFIRED}

@onready var old_state :AbilityStates = AbilityStates.NONE: #
	set(value): if old_state != value:
		old_state = value
		match old_state:
			AbilityStates.NONE:
				pass
			AbilityStates.IDLING:
				pass
			AbilityStates.MOVING:
				pass
			AbilityStates.JUMPING:
				parent.observer_one.emit('jumping', false)
			AbilityStates.RELOADING:
				parent.observer_one.emit('reloading', false)
				parent.observer_one.emit('full_ammo', true)
			AbilityStates.INIT_JUMP:
				parent.observer_one.emit('initializing_jump', false)
			AbilityStates.GUNFIRED:
				pass

@onready var current_state :int = AbilityStates.NONE:
	set(value): if current_state != value:
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
				parent.observer_one.emit('jumping', true)
			AbilityStates.RELOADING:
				parent.observer_one.emit('reloading', true)
			AbilityStates.INIT_JUMP:
				parent.observer_one.emit('initializing_jump', true)
			AbilityStates.GUNFIRED:
				current_state = AbilityStates.IDLING

var is_efficient :bool=false:
	set(value): if is_efficient!=value:
			is_efficient = value
			if_debug('is_efficient: '+ str(is_efficient))
			parent.observer_one.emit('efficiency', is_efficient)

var parent :Player
var anim :AnimatedSprite2D
var children_with_ability_process :Array[Node]

func _ready()->void:
	parent = get_parent()
	anim = parent.get_node('Animations')
	children_with_ability_process = []
	for child:Ability in get_children():
		for property:Variant in child.get_property_list():
			child.parent = self
			child.grandparent = parent
		children_with_ability_process.append(child)
	current_state =AbilityStates.IDLING

func being_physics_process(delta :float)->void:
	for child:Ability in children_with_ability_process:
		child.process_ability(delta)

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
