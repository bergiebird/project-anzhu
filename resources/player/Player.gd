@icon("res://resources/player/player.png") #Player.gd
class_name Player extends AnzhuHuman
@onready var camera :Camera2D = $Camera
@onready var abilities: Node = $Abilities
@onready var listener :AudioListener2D = $AudioListener2D



func human_ready()->void:
	add_to_group('player')

func _physics_process(delta :float)->void:
	velocity = Vector2.ZERO
	abilities.able()
	move_and_slide()

func affect_nightlight(is_leaving_campfire :bool)->void:
	nightlight.campfire_nightlight(is_leaving_campfire)

func change_actions(string_dead :String)->void:
	if string_dead == "Dead":
		Signalton.reload_scene.emit()




###
##Debug
###
func early_ready_for_debug()->void:
	if debug_self:
		debug_icon = "[img]res://resources/player/player.png[/img]"
		print_rich(debug_icon)

func debug()->void:
	pass
