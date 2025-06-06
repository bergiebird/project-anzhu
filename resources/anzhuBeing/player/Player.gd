@icon("res://resources/anzhuBeing/player/player.png")
extends Human
class_name Player

func ___ready():
	Signalton.reference_emitter_deferred("player_reference", self, debug_self)
	add_to_group('player')
	set_collision_layer_value(5,true)

func ___physics_process(_delta :float):
	velocity = Vector2.ZERO

func jumping(needs_inverse :bool):
	collide_with_(1, !needs_inverse)

func has_died():
	Signalton.reload_current_scene()

#region    #===========================================================================================# Debug
func early_ready_for_debug():
	if debug_self:
		debug_icon = "[img]res://resources/player/player.png[/img]"
		print_rich(debug_icon)
 #endregion #===========================================================================================# Debug
