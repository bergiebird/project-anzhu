@icon("res://warehouse/_icons/node/icon_human_controller.png")
class_name Abilities extends Node2D #PlayerAbilities.gd

@export var shoot_cooldown :float = 0.4

signal capability(bol:bool)
var is_capable :bool=true:
	set(value): if is_capable != value:
			is_capable = value
			print('is_capable: ', is_capable)
			capability.emit(is_capable)

signal full_ammo(bol:bool)
var has_full_ammo = true:
	set(value): if has_full_ammo != value:
			has_full_ammo = value
			print('has_full_ammo: ', has_full_ammo)
			full_ammo.emit(has_full_ammo)

signal gunfired(bol :bool)
var is_gunfired :bool=false:
	set(value): if is_gunfired != value:
			is_gunfired = value
			print('is_gunfired: ', is_gunfired)
			gunfired.emit(is_gunfired)
			has_full_ammo = false
			can_move = false
			await get_tree().create_timer(shoot_cooldown).timeout
			can_move = true

signal modified_reload(bol :bool)
var is_reload_modified :bool=false:
	set(value): if is_reload_modified != value: 
			is_reload_modified = true
			print('is_reload_modified: ', is_reload_modified)
			modified_reload.emit(is_reload_modified)
			if is_reload_modified:
				is_reload_modified = false

signal jumping(bol:bool)
var is_jumping :bool=false:
	set(value): if is_jumping!=value:
			is_jumping = value
			print('is_jumping: ', is_jumping)
			jumping.emit(is_jumping)

signal reloading(bol:bool)
var is_reloading :bool=false:
	set(value): if is_reloading!=value:
			is_reloading = value
			print('is_reloading: ', is_reloading)
			reloading.emit(is_reloading)

signal enable_jump(bol:bool)
var can_jump :bool=true:
	set(value): if can_jump!=value:
			can_jump = value
			print('can_jump: ', can_jump)
			enable_jump.emit(can_jump)

signal enable_move(bol:bool)
var can_move :bool=false:
	set(value): if can_move!=value:
			can_move = value
			print('can_move: ', can_move)
			enable_move.emit(can_move)

signal efficiency(bol:bool)
var is_efficient :bool=false:
	set(value): if is_efficient!=value:
			is_efficient = value
			print('is_efficient: ', is_efficient)
			efficiency.emit(is_efficient)

@onready var parent = get_parent()
@onready var anim = parent.get_node('Animations')
@onready var children_with_ability_process :Array[Node]

func _ready()->void:
	for child in get_children():
		child.parent = self
		child.grandparent = parent
		if child.has_method("process_ability"):  
			children_with_ability_process.append(child)
	can_move = true

func process_able()->void:
	for child in children_with_ability_process:
		child.process_ability()

###
##DEBUG
###
@export_group('Debug')
@export var debug_abilities :bool = false
@export var debugger_color :Color = Color("eaf1f0")
@onready var dcolor = debugger_color.to_html()

func debug()->void:
	Debuggerton.enable_print(self.name, dcolor)
	debug_abilities = true
