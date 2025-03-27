extends Marker2D #sfx_gunshot.gd
@onready var flash :PointLight2D = $VfxFlash
@onready var smoke :CPUParticles2D = $VfxSmoke
@onready var smoke2 :CPUParticles2D = $VfxSmoke2
@onready var timer :Timer = $FlashTimer
@onready var gunray :RayCast2D = $GunRay
@onready var DI :Directon = Directon
@export_group('Debug')
@export var debug_gunshot :bool = false
@export var debugger_color :Color = Color("fff1a9")
@onready var debug_string = debugger_color.to_html()

func _ready()->void:
	Signalton.gunshot.connect(sfx_start)
	timer.timeout.connect(flash_out)

func sfx_start()->void:
	match DI.looking_where:
		DI.Looking.NORTH:
			position = Vector2(0.5, -2.0)
			smoke.direction = Vector2(0.0,-1.0)
			smoke.damping_min = 30.0
			smoke2.position = Vector2(0.5, 2.0)
			gunray.rotation_degrees = 270
		DI.Looking.SOUTH:
			position = Vector2(-1.5, 2.0)
			smoke.direction = Vector2(0.0,1.0)
			smoke.damping_min = 30.0
			smoke2.position = Vector2(0.0, -5.0)
			gunray.rotation_degrees = 90
		DI.Looking.WEST:
			position = Vector2(-3.0, -0.5)
			smoke.direction = Vector2(-1.0,0.0)
			smoke.damping_min = 15.0
			smoke2.position = Vector2(3.0,-1.5)
			gunray.rotation_degrees = 180
		DI.Looking.EAST:
			position = Vector2(3.0,-0.5)
			smoke.direction = Vector2(1.0,0.0)
			smoke.damping_min = 15.0
			smoke2.position = Vector2(-3.0,-1.5)
			gunray.rotation_degrees = 0
	timer.start()
	smoke2.emitting = true
	flash.visible = true
	smoke.emitting = true
	gunray.gun_was_fired()

func flash_out() -> void:
	flash.visible = false

func debug()->void:
	Debuggerton.enable_print(self.name, debug_string)
	debug_gunshot = true
