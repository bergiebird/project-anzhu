@icon("res://resources/main_scene/game/game.png")
extends Node2D #GAME.gd

var player :Player:
	set(value):
		if value != player:
			player = value
			if Signalton.saved_state:
				set_player_position()
var tools :Node2D
var global_scene_dictionary :Dictionary
@onready var respawner :Marker2D = %RespawnNode

func _ready()->void:
	assertions()
	Debuggerton.signal_checker([
		Signalton.reload_scene.connect(reload_scene),
		Libraryton.global_delivery.connect(set_global_scene_dictionary),
		Libraryton.player_reference.connect(func(ref :Player)->void: player = ref)])

func reload_scene()->void:
	var error :Error = get_tree().reload_current_scene()
	debug_scene_reloaded(error)
	call_deferred("set_player_position")

func set_player_position()->void:
	player.global_position = respawner.global_position

func set_global_scene_dictionary(incoming_delivery:Dictionary)->void:
	global_scene_dictionary = incoming_delivery
	tools = global_scene_dictionary['NODE2D']['Tools']
	respawner = global_scene_dictionary['NODE2D']['Tools']['RespawnNode']
	assert_set_global_scene_dictionary()

###
## DEBUG
###
@export_group('DEBUG')
@export var debug :bool = false

func assertions()->void:
	if debug:
		assert(player, "Player not found")

func assert_set_global_scene_dictionary()->void:
	if debug:
		assert(global_scene_dictionary, "global_scene_dictionary not properly instantiated in GAME")
		assert(tools, "Tools not properly instantdiated in GAME")
		assert(respawner, "Respawner not properly instantiated in GAME")

func debug_scene_reloaded(error :Error)->void:
	match error:
		OK:
			print('GOOD!')
