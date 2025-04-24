@icon("res://resources/player/abilities/gun/icons8-sniper-rifle-100.png")
extends Node2D #Gun.gd

@export_range(0, 0.5, 0.01) var bullet_travel_time :float = 0.16
@export var shoot_cooldown :float = 0.4
@export var flash_time :float = 0.1
@export var modified_speed_up :float = 0.16
@export var noise_db :float = 300.0

var grandparent :AnzhuHuman

@onready var can_shoot :bool = true
@onready var flash :bool = $VfxFlash.visible:
	set(value): if flash!=value:
		if value:
			flash = value
			await get_tree().create_timer(flash_time).timeout
			flash = false
@onready var smoke_barrel :CPUParticles2D = $VfxSmoke
@onready var smoke_back :CPUParticles2D = $VfxSmoke2
@onready var gunray :RayCast2D = $GunRay
@onready var parent :Abilities:
	set(value): if parent != value:
			parent = value
			parent.full_ammo.connect(func(full_ammo:bool): if full_ammo: parent.is_reloading = false)

func process_ability()->void:
	if parent.is_reloading:          if Inputon.modifier():     parent.is_reload_modified = true
	elif parent.has_full_ammo:      
		print('has full ammo')
		if Inputon.gun_shoot():     
			print('processing')
			process_gunshot()
	elif not parent.has_full_ammo: if Inputon.gun_reload():     parent.is_reloading = true

func process_gunshot()->void:
	parent.is_gunfired = true
	position = Vector2.ZERO
	Directon.gunmatch(self, smoke_barrel, smoke_back, gunray)
	smoke_back.emitting = true
	smoke_barrel.emitting = true
	flash = true
	await get_tree().create_timer(bullet_travel_time).timeout
	gunray.collide_with_bodies = true
	gunray.force_raycast_update()
	if gunray.is_colliding():
		var target_acquired :Object = gunray.get_collider()
		if target_acquired is AnzhuBeing:
			grandparent.strike_target(1,"gun",target_acquired)
			gunray.collide_with_bodies = false

###
##DEBUGGER
###
@export_group('Debug')
@export var debug_gunshot :bool = false
@export var debugger_color :Color = Color("fff1a9")
@onready var debug_string = debugger_color.to_html()

func debug()->void:
	Debuggerton.enable_print(self.name, debug_string)
	debug_gunshot = true
