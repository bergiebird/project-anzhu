extends AudioStreamPlayer2D #CostalWaves.gd
var player :Player

func _ready() -> void:
	set_process(false)
	Libraryton.player_reference.connect(find_player)

func find_player(incoming_value :Player)->void:
	player = incoming_value
	set_process(true)

func _process(delta :float)->void:
	global_position.y = player.global_position.y
