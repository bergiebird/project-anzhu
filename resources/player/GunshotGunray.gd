extends RayCast2D #GunshotGunray.gd

@onready var hit_time :Timer = $HitTime
@onready var delay_time :Timer = $DelayTime

func gun_was_fired()->void:
	delay_time.start()

func _on_hit_time_timeout() -> void:
	collide_with_bodies = false

func _on_delay_time_timeout() -> void:
	hit_time.start()
	collide_with_bodies = true
	force_raycast_update()
	if is_colliding():
		get_collider().got_hit()
