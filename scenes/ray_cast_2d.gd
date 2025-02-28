extends RayCast2D

@onready var child_time :Timer = $HitTime

func _ready()->void:
	Signalton.gunshot.connect(gun_was_fired)

func gun_was_fired()->void:
	match Enumerton.looking_where:
		Enumerton.Looking.NORTH: rotation_degrees = 270
		Enumerton.Looking.SOUTH: rotation_degrees = 90
		Enumerton.Looking.WEST:  rotation_degrees = 180
		Enumerton.Looking.EAST:  rotation_degrees = 0
	child_time.start()
	collide_with_bodies = true
	force_raycast_update()
	if is_colliding():
		get_collider().got_hit()

func _on_hit_time_timeout() -> void:
	collide_with_bodies = false
