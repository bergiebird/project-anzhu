extends Node #polar_bear_hit.gd

signal polar_bear_shot()
signal reset_movement_speed()
signal hunt_player(hunt :String)

@onready var slow_timer :Timer = $SlowTimer
var was_just_hit = false

func start()->void:
	slow_timer.start()
	was_just_hit = true
	polar_bear_shot.emit()

func _on_slow_timer_timeout() -> void:
	reset_movement_speed.emit()

func unstun()->void:
	if was_just_hit:
		was_just_hit = false
		hunt_player.emit("Hunt")

func _unprocess()->void:
	set_physics_process(false)
	set_process(false)
