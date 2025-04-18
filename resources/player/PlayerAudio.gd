extends AudioManager
var reload
var default_pitch :float

@onready var abilities = %Abilities
@onready var anim = %Animations
@export var modified_speed_up = 0.16

func ready() -> void:
	reload = audio_dictionary['reload']
	default_pitch = reload.pitch_scale

func signaler()->void:
	abilities.start_reload.connect(func(): reload.play())
	anim.reloaded.connect(func(): reload.pitch_scale = default_pitch)
	abilities.modified_reload.connect(func(): reload.pitch_scale += modified_speed_up)
