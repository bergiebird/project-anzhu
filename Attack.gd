
class_name Attack
extends Resource

@export_enum("gun", "hatchet", "claw") var weapon: String
@export var damage: int = 0

var attacker: AnzhuBeing
var victim: AnzhuBeing:
	set(v):
		if v != victim and v != attacker:
			victim = v
