extends HurtBox #BearHurtBox.gd

func _on_body_entered(body :AnzhuBeing)->void:
	if not on_cooldown:
		parent.strike_target(1,"bite",body)
		on_cooldown = true
		hurt_timer.start()

func _physics_process(_delta :float)->void:
	update_and_match_attacking_direction(parent.get_real_velocity().abs())
