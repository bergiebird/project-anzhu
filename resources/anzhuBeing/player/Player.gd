@icon("res://resources/anzhuBeing/player/player.png")

extends Human
class_name Player

static var ref: Player

func ___ready() -> void:
	ref = self
	Sgnl.reference_emitter_deferred("player_reference", self, debug_self)
	if not is_in_group('player'):
		add_to_group('player')


func ___physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO


func jumping(needs_inverse: bool) -> void:
	collide_with_(1, !needs_inverse)


func _has_died() -> void:
	Sgnl.reload_current_scene()


func early_ready_for_debug() -> void:
	if debug_self:
		debug_icon = "[img]res://resources/player/player.png[/img]"
		print_rich(debug_icon)
