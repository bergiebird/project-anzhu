extends Marker2D #sfx_gunshot.gd
@onready var flash :PointLight2D = $VfxFlash
@onready var smoke :CPUParticles2D = $VfxSmoke
@onready var smoke2 :CPUParticles2D = $VfxSmoke2
@onready var flashtime :Timer = $FlashTime
@onready var gunray :RayCast2D = $GunRay
@onready var directon :Directon = Directon

func _ready()->void:
	Signalton.gunshot.connect(sfx_start)

func sfx_start()->void:
	match directon.looking_where:
		directon.Looking.NORTH:
			position = Vector2(0.5, -4.0)
			smoke.direction = Vector2(0.0,-1.0)
			smoke.damping_min = 30.0
			smoke2.position = Vector2(0.5, 2.0)
			gunray.rotation_degrees = 270
		directon.Looking.SOUTH:
			position = Vector2(-1.5, 4.0)
			smoke.direction = Vector2(0.0,1.0)
			smoke.damping_min = 30.0
			smoke2.position = Vector2(0.0, -5.0)
			gunray.rotation_degrees = 90
		directon.Looking.WEST:
			position = Vector2(-4.0, -0.5)
			smoke.direction = Vector2(-1.0,0.0)
			smoke.damping_min = 15.0
			smoke2.position = Vector2(3.0,-1.5)
			gunray.rotation_degrees = 180
		directon.Looking.EAST:
			position = Vector2(4.0,-0.5)
			smoke.direction = Vector2(1.0,0.0)
			smoke.damping_min = 15.0
			smoke2.position = Vector2(-3.0,-1.5)
			gunray.rotation_degrees = 0
	flashtime.start()
	smoke2.emitting = true
	flash.visible = true
	smoke.emitting = true
	gunray.gun_was_fired()


func _on_flash_time_timeout() -> void:
	flash.visible = false
