extends GoalState
class_name GoalHunt

var target: AnzhuBeing

@onready var bgm_hunt: AudioStreamPlayer2D =  $BgmHunt
@onready var sfx_spotted: AudioStreamPlayer2D = $SfxSpotted
@onready var sfx_out_of_sight: AudioStreamPlayer2D = $SfxOutOfSight

func ___get_state_value(_parent: StateMachine):
	which_state = _parent.AnimalGoals.Hunt

func ___enter():
	bgm_hunt.play()
	Sgnl.bear_chasing.emit(true, bgm_hunt)
	grandparent.publish_event.emit("change_actions", "Chase")

func player_out_of_sight(): if is_active:
		sfx_out_of_sight.play()

func player_spotted(): if is_active:
		sfx_spotted.play()
