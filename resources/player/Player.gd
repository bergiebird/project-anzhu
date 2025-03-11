@icon("res://resources/player/player.png")
class_name Player extends AnzhuHuman #Player.gd
@onready var camera :Camera2D = $Camera2D
@onready var abilities: Node = $Abilities
@onready var listener :AudioListener2D = $AudioListener2D

func human_ready()->void:
	Signalton.player_hit.connect(human_was_hit)

func _physics_process(delta :float)->void:
	velocity = Vector2.ZERO
	abilities.able()
	move_and_slide()


func affect_nightlight(is_leaving_campfire :bool)->void:
	nightlight.campfire_nightlight(is_leaving_campfire)

func human_was_hit()->void:
	scenes_nodes['Animations'].was_just_hit()
	scenes_nodes['Stats'].increment_values()
