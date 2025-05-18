@icon("res://resources/anzhuBeing/player/player.png")
class_name Player extends Human

func ___ready()->void:
	Libraryton.reference_emitter_deferred("player_reference", self, debug_self)
	add_to_group('player')

func ___physics_process(_delta :float)->void:
	velocity = Vector2.ZERO

func ___signaler()->void:
	publisher_one.connect(func(func_name, one): Observerton.subscribe_one(self, func_name, one))

func jumping(needs_inverse :bool)->void:
	set_collision_layer_value(1, !needs_inverse)
	set_collision_mask_value(1, !needs_inverse)

#region	Debug
func early_ready_for_debug()->void:
	if debug_self:
		debug_icon = "[img]res://resources/player/player.png[/img]"
		print_rich(debug_icon)

 #endregion
