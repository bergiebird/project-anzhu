extends HurtBox
class_name BearHurtBox

@onready var attack: Attack = Attack.new()
@onready var sfx_strike: AudioStreamPlayer2D = $SfxStrike

func __ready():
	attack.attacker = get_parent()
	attack.weapon = "claw"
	attack.damage = 1


func _on_body_entered(body: Node2D) -> void:
	if on_cooldown:
		return
	if body is not AnzhuBeing:
		return
	on_cooldown = true
	attack.victim = body
	parent.publish_event.emit("strike_target", attack)
	hurt_timer.start()

func _physics_process(_delta: float):
	update_and_match_attacking_direction(parent.get_real_velocity().abs())

func was_just_hit():
	monitoring = false

func strike_target(_attack: Attack):
	sfx_strike.play()
