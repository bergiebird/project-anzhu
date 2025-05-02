@icon("res://resources/anzhuBeing/player/abilities/gun/icons8-sniper-rifle-100.png")
extends Ability #Gun.gd

@export_range(0, 0.5, 0.01) var bullet_travel_time :float = 0.16
@export var shoot_cooldown :float = 0.1
@export var flash_time :float = 0.1
@export var modified_speed_up :float = 0.16
@export var noise_db :float = 300.0



@onready var can_shoot :bool = true
@onready var vfx_flash :PointLight2D = $VfxFlash
@onready var flash :bool = vfx_flash.visible:
	set(value): if flash!=value:
		flash = value
		if flash:
			await get_tree().create_timer(flash_time).timeout
			flash = false
@onready var smoke_barrel :CPUParticles2D = $VfxSmoke
@onready var smoke_back :CPUParticles2D = $VfxSmoke2
@onready var gunray :RayCast2D = $GunRay

func _parent_set()->void:
	if not parent.is_connected("full_ammo", reload_finished):
		Debuggerton.signal_checker([parent.full_ammo.connect(reload_finished)])

func process_ability(_delta :float)->void:
	if parent.is_reloading:
		if Inputon.modifier():
			parent.is_reload_modified = true
	elif parent.has_full_ammo:
		if Inputon.gun_shoot():
			process_gunshot()
	elif not parent.has_full_ammo:
		if Inputon.gun_reload():
			parent.is_reloading = true

func process_gunshot()->void:
	position = Vector2.ZERO
	parent.is_gunfired = true
	parent.has_full_ammo = false
	parent.can_move = false
	Directon.gunmatch(self, smoke_barrel, smoke_back, gunray)
	smoke_back.emitting = true
	smoke_barrel.emitting = true
	flash = true
	await get_tree().create_timer(shoot_cooldown).timeout
	parent.can_move = true
	await get_tree().create_timer(bullet_travel_time).timeout
	gunray.collide_with_bodies = true
	gunray.force_raycast_update()
	if gunray.is_colliding():
		var target_acquired :AnzhuBeing = gunray.get_collider()
		grandparent.strike_target(1,"gun",target_acquired)
		gunray.collide_with_bodies = false

func reload_finished(has_ammo :bool)->void:
	if has_ammo:
		parent.can_move = true
		parent.is_reloading = false
		parent.is_gunfired = false

###
##DEBUGGER
###
@export_group('Debug')
@export var debug_gunshot :bool = false
@export var debugger_color :Color = Color("fff1a9")

func debug()->void:
	Debuggerton.enable_print(self.name, debugger_color)
	debug_gunshot = true
