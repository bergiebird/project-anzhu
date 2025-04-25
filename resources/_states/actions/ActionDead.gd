extends ActionState #ActionDead.gd
@export var has_death_howl :bool = false
@onready var timer :Timer = $Timer
var corpse_node :Area2D
var hurtbox :HurtBox
var audio :AudioManager

func _ready() -> void:
	timer.timeout.connect(begin_end_of_life)

func enter()->void:
	hurtbox.monitoring = false
	if has_death_howl:
		audio.start_sfx(self.name)
		timer.start()
	else:
		begin_end_of_life()

func update(delta:float)->void:
	pass

func physics_update(delta:float)->void:
	pass

func begin_end_of_life()->void:
	corpse_node.end_of_life()

func _collect_dictionary(incoming_dictionary)->void:
	corpse_node = incoming_dictionary['Corpse']
	hurtbox = incoming_dictionary['HurtBox']
	audio = incoming_dictionary['AudioManager']
