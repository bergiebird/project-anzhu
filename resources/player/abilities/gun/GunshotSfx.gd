extends Marker2D #sfx_gunshot.gd

@export_range(0, 0.5, 0.01) var bullet_travel_time :float = 0.16
@onready var parent :AnzhuHuman = get_parent()
@onready var DI :Directon = Directon
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

func _ready()->void:
	Signalton.gunshot.connect(sfx_start)
	delay_timer.wait_time = bullet_travel_time

func sfx_start()->void:
	position = Vector2.ZERO
	match DI.looking_where:
		DI.Looking.NORTH:
			position = north.position
			smoke_barrel.direction = Vector2.UP
			smoke_back.position = Vector2.DOWN
			gunray.rotation_degrees = DI.ROTATE_NORTH
		DI.Looking.WEST:
			position = west.position
			smoke_barrel.direction = Vector2.LEFT
			smoke_back.position = Vector2(3.0, 0.0)
			gunray.rotation_degrees = DI.ROTATE_WEST
		DI.Looking.SOUTH:
			position = south.position
			smoke_barrel.direction = Vector2.DOWN
			smoke_back.position = Vector2(0.0, -5.0)
			gunray.rotation_degrees = DI.ROTATE_SOUTH
		DI.Looking.EAST:
			position = east.position
			smoke_barrel.direction = Vector2.RIGHT
			smoke_back.position = Vector2(-3.0, 0.0)
			gunray.rotation_degrees = DI.ROTATE_EAST
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
		if who is AnzhuCharacter:
			parent.strike_target(1,"gun",who)
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
