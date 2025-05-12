@icon("res://warehouse/_icons/node/icon_human_controller.png")
class_name Abilities extends Node2D #PlayerAbilities.gd

@export var shoot_cooldown :float = 0.4

var is_capable :bool=true:
	set(value): if is_capable != value:
			is_capable = value
			if_debug('is_capable: '+ str(is_capable))
			parent.observer_one.emit('capability', is_capable)

var has_full_ammo :bool= true:
	set(value): if has_full_ammo != value:
			has_full_ammo = value
			if_debug('has_full_ammo: '+ str(has_full_ammo))
			parent.observer_one.emit('full_ammo', has_full_ammo)

var is_gunfired :bool=false:
	set(value): if is_gunfired != value:
			is_gunfired = value
			if_debug('is_gunfired: '+ str(is_gunfired))
			parent.observer_one.emit('gunfired', is_gunfired)

var is_reload_modified :bool=false:
	set(value): if is_reload_modified != value:
			is_reload_modified = true
			if_debug('is_reload_modified: '+ str(is_reload_modified))
			parent.observer_one.emit('modified_reload', is_reload_modified)
			if is_reload_modified:
				is_reload_modified = false

var is_jumping :bool=false:
	set(value): if is_jumping!=value:
			is_jumping = value
			if_debug('is_jumping: '+ str(is_jumping))
			parent.observer_one.emit('jumping', is_jumping)

var is_initializing_jump :bool=false:
	set(value): if value != is_initializing_jump:
		is_initializing_jump = value
		if_debug('is initializing_jump: ' + str(is_initializing_jump))
		parent.observer_one.emit('initializing_jump', is_initializing_jump)
		can_move = !is_initializing_jump

var is_reloading :bool=false:
	set(value): if is_reloading!=value:
			is_reloading = value
			if_debug('is_reloading: '+ str(is_reloading))
			parent.observer_one.emit('reloading', is_reloading)

var can_jump :bool=true:
	set(value): if can_jump!=value:
			can_jump = value
			if_debug('can_jump: '+ str(can_jump))
			parent.observer_one.emit('enable_jump', can_jump)

var can_move :bool=false:
	set(value): if can_move!=value:
			can_move = value
			if_debug('can_move: '+ str(can_move))
			parent.observer_one.emit('enable_move', can_move)
			if can_move:
				parent.velocity = Vector2.ZERO

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
	can_move = true

func being_physics_process(delta :float)->void:
	for child:Ability in children_with_ability_process:
		child.process_ability(delta)

###
##DEBUG
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
