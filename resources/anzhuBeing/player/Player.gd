@icon("res://resources/anzhuBeing/player/player.png")

class_name Player
extends Human


func ___ready():
	Sgnl.reference_emitter_deferred("player_reference", self, debug_self)
	if not is_in_group('player'):
		add_to_group('player')


func ___physics_process(_delta: float):
	velocity = Vector2.ZERO


func jumping(needs_inverse: bool):
	collide_with_(1, !needs_inverse)


func has_died():
	Sgnl.reload_current_scene()


#region Debug
func early_ready_for_debug():
	if debug_self:
		debug_icon = "[img]res://resources/player/player.png[/img]"
		print_rich(debug_icon)
 #endregion
