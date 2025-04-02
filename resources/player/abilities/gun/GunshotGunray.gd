extends RayCast2D #GunshotGunray.gd

@onready var hit_time :Timer = $HitTimer
@onready var delay_time :Timer = $DelayTimer

func _ready() -> void:
	hit_time.timeout.connect(_on_hit_time_timeout)
	delay_time.timeout.connect(_on_delay_time_timeout)

func gun_was_fired()->void:
	delay_time.start()

func _on_hit_time_timeout() -> void:
	collide_with_bodies = false

func _on_delay_time_timeout() -> void:
	hit_time.start()
	collide_with_bodies = true
	force_raycast_update()
	if is_colliding():
		var collider_gotten :Object = get_collider()
		if collider_gotten.has_method('got_hit'):
			collider_gotten.got_hit()
