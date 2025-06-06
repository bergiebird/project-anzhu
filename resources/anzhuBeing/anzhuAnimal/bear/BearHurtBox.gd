extends HurtBox
class_name BearHurtBox

@onready var sfx_strike :AudioStreamPlayer2D = $SfxStrike

func _on_body_entered(body :Node2D)->void:
	if not on_cooldown and body is AnzhuBeing:
		on_cooldown = true
		parent.publish_event.emit("strike_target",
			{
				"DAMAGE": 1,
				"WEAPON": "bite",
				"ATTACKER": parent,
				"VICTIM": body,
			})
		hurt_timer.start()

func _physics_process(_delta :float):
	update_and_match_attacking_direction(parent.get_real_velocity().abs())

func was_just_hit():
	monitoring = false

func strike_target(_attack :Dictionary):
	sfx_strike.play()
