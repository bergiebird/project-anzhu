class_name BearCorpse extends Corpse

@onready var sfx_death_howl = $SfxDeathHowl

func _has_died():
	sfx_death_howl.play()
	await get_tree().create_timer(sfx_death_howl.get_stream().get_length() + 0.1).timeout
