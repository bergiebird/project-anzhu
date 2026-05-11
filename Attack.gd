
class_name Attack
extends Resource

enum AttackType{
	NONE
}

@export var damage: int = 0
@export var weapon: AttackType

var attacker: AnzhuBeing
var victim: AnzhuBeing:
	set(v):
		if v != victim and v != attacker:
			victim = v
