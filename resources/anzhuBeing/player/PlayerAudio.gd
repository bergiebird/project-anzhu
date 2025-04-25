extends AudioManager

@export var modified_speed_up = 0.16
@onready var reload :AudioStreamPlayer2D = $ReloadSFX
@onready var gunshot :AudioStreamPlayer2D = $GunshotSFX
@onready var reload_default_pitch :float = reload.pitch_scale
var abilities :Abilities:
	set(value): if abilities != value:
		abilities = value
		abilities.reloading.connect(reloader)
		abilities.gunfired.connect(fire_gun_audio)

func __ready() -> void:
	abilities = parent.get_node("Abilities")

func reloader(bol :bool)->void:
	if bol:
		reload.play()
	else:
		reload.pitch_scale = reload_default_pitch

func fire_gun_audio(bol :bool)->void:
	if bol:
		gunshot.play()
