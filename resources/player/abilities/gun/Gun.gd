@icon("res://resources/player/abilities/gun/icons8-sniper-rifle-100.png")
extends Node2D #Gun.gd

@export_range(0, 0.5, 0.01) var bullet_travel_time :float = 0.16
@export var shoot_cooldown :float = 0.4
var reload_audio
var anim
@onready var flash :PointLight2D = $VfxFlash
@onready var smoke_barrel :CPUParticles2D = $VfxSmoke
@onready var smoke_back :CPUParticles2D = $VfxSmoke2
@onready var gunray :RayCast2D = $GunRay
@onready var flash_timer :Timer = $FlashTimer
@onready var delay_timer :Timer = $DelayTimer
@onready var north :Marker2D = $NorthAim
@onready var west :Marker2D =$WestAim
@onready var south :Marker2D = $SouthAim
@onready var east :Marker2D =$EastAim
@onready var parent :Abilities = get_parent()
@onready var grandparent :AnzhuHuman = parent.get_parent()

func _ready()->void:
	Signalton.gunshot.connect(sfx_start)
	delay_timer.wait_time = bullet_travel_time

func reload()->void:
	if Inputon.gun():
		if not parent.is_loaded:
			parent.start_reload.emit()
			anim.start_reload_animation()

func modify_reload()->void:
	if Inputon.modifier():
		parent.modified_reload.emit()

func shoot()->void:
	if Inputon.gun():
		Signalton.gunshot.emit()

func sfx_start()->void:
	position = Vector2.ZERO
	match Directon.looking_where:
		Directon.Looking.NORTH:
			position = north.position
			smoke_barrel.direction = Vector2.UP
			smoke_back.position = Vector2.DOWN
			gunray.rotation_degrees = Directon.ROTATE_NORTH
		Directon.Looking.WEST:
			position = west.position
			smoke_barrel.direction = Vector2.LEFT
			smoke_back.position = Vector2(3.0, 0.0)
			gunray.rotation_degrees = Directon.ROTATE_WEST
		Directon.Looking.SOUTH:
			position = south.position
			smoke_barrel.direction = Vector2.DOWN
			smoke_back.position = Vector2(0.0, -5.0)
			gunray.rotation_degrees = Directon.ROTATE_SOUTH
		Directon.Looking.EAST:
			position = east.position
			smoke_barrel.direction = Vector2.RIGHT
			smoke_back.position = Vector2(-3.0, 0.0)
			gunray.rotation_degrees = Directon.ROTATE_EAST
	flash_timer.start()
	smoke_back.emitting = true
	flash.visible = true
	smoke_barrel.emitting = true
	gun_was_fired()

func flash_out() -> void:
	flash.visible = false

func gun_was_fired()->void:
	delay_timer.start()
func try_to_hit() ->void:
	gunray.collide_with_bodies = true
	gunray.force_raycast_update()
	if gunray.is_colliding():
		var who :Object = gunray.get_collider()
		if who is AnzhuBeing:
			grandparent.strike_target(1,"gun",who)
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
