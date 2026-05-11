extends HurtBox
class_name BearHurtBox


signal strike_target(atk: Attack)

var attack: Attack

@onready var sfx_strike: AudioStreamPlayer2D = $SfxStrike


func __ready() -> void:
	attack = Attack.new()
	attack.attacker = parent
	attack.weapon = Attack.AttackType.NONE
	attack.damage = 1


func _on_body_entered(body: Node2D) -> void:
	if on_cooldown:
		return
	if body is not AnzhuBeing:
		return
	on_cooldown = true
	attack.victim = body
	strike_target.emit(attack)

	hurt_timer.start()
	sfx_strike.play()


func _physics_process(_delta: float):
	update_and_match_attacking_direction(parent.get_real_velocity().abs())


func was_just_hit():
	monitoring = false
