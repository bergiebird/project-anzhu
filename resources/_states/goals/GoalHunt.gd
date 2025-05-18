extends GoalState #GoalHunt.gd

var target :AnzhuBeing
@onready var bgm_hunt :AudioStreamPlayer2D =  $BgmHunt
@onready var sfx_spotted :AudioStreamPlayer2D = $SfxSpotted
@onready var sfx_out_of_sight :AudioStreamPlayer2D = $SfxOutOfSight

func ___ready()->void:
	Libraryton.player_reference.connect(func(ref:Player)->void: target = ref)
	grandparent.publisher_null.connect(func(func_name): Observerton.subscribe_null(self, func_name))

func ___get_state_value(_parent :StateMachine):
	which_state = _parent.AnimalGoals.Hunt

func ___enter()->void:
	if Audioton.can_bear_boogie(grandparent):               # Not a perfect system, Audioton only allows one bear to boogie
		bgm_hunt.play()
	grandparent.publisher_one.emit("change_actions", "Chase")

func player_out_of_sight()->void:
	if is_active:
		sfx_out_of_sight.play()

func player_spotted():
	if is_active:
		sfx_spotted.play
