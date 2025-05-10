@icon("res://gyms/mainScene/game.png")
extends Node2D #GAME.gd

var tools :Node2D
var global_scene_dictionary :Dictionary
@onready var respawner :Marker2D = %RespawnNode

func _ready()->void:
	Libraryton.global_delivery.connect(set_global_scene_dictionary)


func set_global_scene_dictionary(incoming_delivery :Dictionary)->void:
	global_scene_dictionary = incoming_delivery
	tools = global_scene_dictionary['NODE2D']['Tools']
	respawner = global_scene_dictionary['NODE2D']['Tools']['RespawnNode']
	assert_set_global_scene_dictionary()


#region DEBUG
@export_group('DEBUG')
@export var debug :bool = false

func assert_set_global_scene_dictionary()->void:
	if debug:
		assert(global_scene_dictionary, "global_scene_dictionary not properly instantiated in GAME")
		assert(tools, "Tools not properly instantdiated in GAME")
		assert(respawner, "Respawner not properly instantiated in GAME")
#endregion
