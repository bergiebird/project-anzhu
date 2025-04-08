@icon("res://resources/_singletons/game/game.png")
extends Node2D #GAME.gd

@onready var player :Player = %Player
@onready var S :Signalton = Signalton
@onready var I :Object = Input
var tools :Node2D
var respawner :Marker2D
var global_scene_dictionary :Dictionary

func _ready()->void:
	if debug: assertions()
	S.reload_scene.connect(reload_scene)
	I.set_mouse_mode(I.MOUSE_MODE_HIDDEN)
	Libraryton.global_delivery.connect(set_global_scene_dictionary)
	if S.saved_state:
		set_player_position()

func reload_scene()->void:
	get_tree().reload_current_scene()
	call_deferred("set_player_position")

func set_player_position()->void:
	player.global_position = respawner.global_position

func set_global_scene_dictionary(incoming_delivery:Dictionary)->void:
	global_scene_dictionary = incoming_delivery
	tools = global_scene_dictionary['NODE2D']['Tools']
	respawner = global_scene_dictionary['NODE2D']['Tools']['RespawnNode']
	if debug: assert_set_global_scene_dictionary()







###
## DEBUG
###
@export_group('DEBUG')
@export var debug :bool = false

func assertions()->void:
	assert(player, "Player not found")

func assert_set_global_scene_dictionary()->void:
	assert(global_scene_dictionary, "global_scene_dictionary not properly instantiated in GAME")
	assert(tools, "Tools not properly instantiated in GAME")
	assert(respawner, "Respawner not properly instantiated in GAME")
