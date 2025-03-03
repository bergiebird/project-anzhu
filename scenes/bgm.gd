extends AudioStreamPlayer
@onready var player = %Player
@onready var bear = %PolarBear
var can_toggle = true
var cooldown = 0.5
func music_change()->void:
	stop()
	set_process(true)

func _ready()->void:
	set_process(false)

func _process(_delta:float)->void:
	if not can_toggle:return
	var diff = player.position - bear.position
	var distance = diff.length()  # Get the actual distance

	# Start playing if distance exceeds 125
	if distance > 510 and not is_playing():
		volume_db = -20
		create_tween().tween_property(self, 'volume_db', 0, 5 )
		_set_playing(true)
	# Stop playing when distance is less than 120
	elif distance < 480 and is_playing():
		_set_playing(false)

func start_cooldown():
	can_toggle = false
	await get_tree().create_timer(cooldown).timeout
	can_toggle = true
