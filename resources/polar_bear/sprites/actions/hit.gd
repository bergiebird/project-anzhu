extends Node #polar_bear_hit.gd

signal polar_bear_shot()
signal reset_movement_speed()
signal hunt_player(hunt :String)

@onready var slow_timer :Timer = $SlowTimer
var was_just_hit = false

func got_hit()->void:
	slow_timer.start()
	was_just_hit = true
	polar_bear_shot.emit()

func _on_slow_timer_timeout() -> void:
	reset_movement_speed.emit()

func _stun_over()->void:
	if was_just_hit:
		was_just_hit = false
		hunt_player.emit("Hunt")

func start()->void:
	got_hit()
