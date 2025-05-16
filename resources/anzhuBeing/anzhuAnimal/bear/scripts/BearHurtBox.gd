class_name BearHurtBox extends HurtBox

func _on_body_entered(body :AnzhuBeing)->void:
	if not on_cooldown:
		on_cooldown = true
		parent.publisher_three.emit("strike_target", 1, "bite", body)
		hurt_timer.start()

func _physics_process(_delta :float)->void:
	update_and_match_attacking_direction(parent.get_real_velocity().abs())

func was_just_hit():
	set_hurtbox_monitoring(false)
