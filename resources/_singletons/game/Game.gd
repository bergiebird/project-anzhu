@icon("res://resources/_singletons/game/game.png")
extends Node2D #GAME.gd

@onready var player :Player = %Player
@onready var respawner :Marker2D = %RespawnNode
@onready var S :Signalton = Signalton
@onready var I :Object = Input

func _ready()->void:
	I.set_mouse_mode(I.MOUSE_MODE_HIDDEN)
	S.reload_scene.connect(reload_scene)
	if S.saved_state:
		set_player_position()

func reload_scene()->void:
	get_tree().reload_current_scene()
	call_deferred("set_player_position")

func set_player_position()->void:
	player.global_position = respawner.global_position
