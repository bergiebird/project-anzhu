@icon("res://warehouse/_icons/node/icon_human_controller.png")
class_name Abilities extends Node2D #PlayerAbilities.gd

@export var shoot_cooldown :float = 0.4

signal capability(bol:bool)
var is_capable :bool=true:
	set(value): if is_capable != value:
			is_capable = value
			if_debug('is_capable: '+ str(is_capable))
			capability.emit(is_capable)

signal full_ammo(bol:bool)
var has_full_ammo :bool= true:
	set(value): if has_full_ammo != value:
			has_full_ammo = value
			if_debug('has_full_ammo: '+ str(has_full_ammo))
			full_ammo.emit(has_full_ammo)

signal gunfired(bol :bool)
var is_gunfired :bool=false:
	set(value): if is_gunfired != value:
			is_gunfired = value
			if_debug('is_gunfired: '+ str(is_gunfired))
			gunfired.emit(is_gunfired)

signal modified_reload(bol :bool)
var is_reload_modified :bool=false:
	set(value): if is_reload_modified != value:
			is_reload_modified = true
			if_debug('is_reload_modified: '+ str(is_reload_modified))
			modified_reload.emit(is_reload_modified)
			if is_reload_modified:
				is_reload_modified = false

signal jumping(bol:bool)
var is_jumping :bool=false:
	set(value): if is_jumping!=value:
			is_jumping = value
			if_debug('is_jumping: '+ str(is_jumping))
			jumping.emit(is_jumping)

signal initializing_jump(bol:bool)
var is_initializing_jump :bool=false:
	set(value): if value != is_initializing_jump:
		is_initializing_jump = value
		if_debug('is initializing_jump: ' + str(is_initializing_jump))
		initializing_jump.emit(is_initializing_jump)
		can_move = !is_initializing_jump

signal reloading(bol:bool)
var is_reloading :bool=false:
	set(value): if is_reloading!=value:
			is_reloading = value
			if_debug('is_reloading: '+ str(is_reloading))
			reloading.emit(is_reloading)

signal enable_jump(bol:bool)
var can_jump :bool=true:
	set(value): if can_jump!=value:
			can_jump = value
			if_debug('can_jump: '+ str(can_jump))
			enable_jump.emit(can_jump)

signal enable_move(bol:bool)
var can_move :bool=false:
	set(value): if can_move!=value:
			can_move = value
			if_debug('can_move: '+ str(can_move))
			enable_move.emit(can_move)
			if can_move:
				parent.velocity = Vector2.ZERO

signal efficiency(bol:bool)
var is_efficient :bool=false:
	set(value): if is_efficient!=value:
			is_efficient = value
			if_debug('is_efficient: '+ str(is_efficient))
			efficiency.emit(is_efficient)

@onready var parent :Player = get_parent()
@onready var anim :AnimatedSprite2D = parent.get_node('Animations')
@onready var children_with_ability_process :Array[Node]

func _ready()->void:
	for child:Ability in get_children():
		for property:Variant in child.get_property_list():
			child.parent = self
			child.grandparent = parent
		children_with_ability_process.append(child)
	can_move = true

func being_physics_process(delta :float)->void:
	for child :Ability in children_with_ability_process:
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
