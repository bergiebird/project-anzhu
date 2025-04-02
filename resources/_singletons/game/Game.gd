@icon("res://resources/_singletons/game/game.png")
extends Node2D #GAME.gd

@onready var player :Player = %Player
@onready var S :Signalton = Signalton
@onready var I :Object = Input
@onready var L :Libraryton = Libraryton
var tools :Node2D
var respawner :Marker2D
var global_scene_dictionary :Dictionary

func _ready()->void:
	assert(player, "Player not found")
	assert(S, "Singalton not found in Global Scope")
	assert(I, "Input not found in Global Scope")
	assert(L, "Libraryton not found in GlobalScope")
	S.reload_scene.connect(reload_scene)
	I.set_mouse_mode(I.MOUSE_MODE_HIDDEN)
	L.global_delivery.connect(set_global_scene_dictionary)
	if S.saved_state:
		set_player_position()

func reload_scene()->void:
	get_tree().reload_current_scene()
	call_deferred("set_player_position")

func set_player_position()->void:
	player.global_position = respawner.global_position

func set_global_scene_dictionary(incoming_delivery:Dictionary)->void:
	global_scene_dictionary = incoming_delivery
	assert(global_scene_dictionary, "global_scene_dictionary not properly instantiated in GAME")
	tools = global_scene_dictionary['NODE2D']['Tools']
	assert(tools, "Tools not properly instantiated in GAME")
	respawner = global_scene_dictionary['NODE2D']['Tools']['RespawnNode']
	assert(respawner, "Respawner not properly instantiated in GAME")
