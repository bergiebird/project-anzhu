@icon("res://resources/anzhuBeing/player/abilities/gun/icons8-sniper-rifle-100.png")

class_name Gunshot
extends Ability

@export_range(0, 0.5, 0.01) var bullet_travel_time: float = 0.26
@export var flash_time: float = 0.1
@export var modified_speed_up: float = 0.16
@export var noise_db: float = 300.0
@export var attack_gunshot: Attack

var is_empty: bool = false

@onready var can_shoot: bool = true
@onready var smoke_barrel: CPUParticles2D = $VfxSmoke
@onready var smoke_back: CPUParticles2D = $VfxSmoke2
@onready var gunray: RayCast2D = $GunRay
@onready var sfx_gunshot: AudioStreamPlayer = $SfxGunshot
@onready var vfx_flash: PointLight2D = $VfxFlash
@onready var timer_flash: Timer = $FlashTime
@onready var flash: bool = vfx_flash.visible:
	set(v):
		flash = v
		if flash:
			timer_flash.start()

func _grandparent_set():
	grandparent.publish_event.connect(func(func_name:String, data:Variant=null):Lib.Observe.subscribe_to_event(self, func_name, data))


func _process(_delta: float):
	match parent.current_state:
		parent.AbilityStates.RELOADING:
			pass
		parent.AbilityStates.IDLING:
			if not is_empty:
				if Input.is_action_just_pressed('gun'):
					process_gunshot()
			elif is_empty and Inputon.gun_reload():
				parent.current_state = parent.AbilityStates.RELOADING


func process_gunshot():
	Sgnl.loud_noise.emit(grandparent,grandparent.global_position, noise_db)
	is_empty = true
	sfx_gunshot.play()
	position = Vector2.ZERO
	Directon.gunmatch(self, smoke_barrel, smoke_back, gunray, grandparent.current_direction)
	smoke_back.emitting = true
	smoke_barrel.emitting = true
	flash = true
	await get_tree().create_timer(bullet_travel_time).timeout
	gunray.collide_with_bodies = true
	gunray.force_raycast_update()
	if gunray.is_colliding():
		attack_gunshot.victim = gunray.get_collider()
		#grandparent.strike_target(attack_gunshot)
		gunray.collide_with_bodies = false


func full_ammo(has_ammo: bool):
	is_empty = !has_ammo


func _on_flash_time_timeout() -> void:
	flash = false
