extends GoalState #GoalHunt.gd

var target :AnzhuBeing

func ___enter()->void:
	if grandparent.is_in_group('Bear'):
		Audioton.can_bear_boogie(grandparent)
		Libraryton.player_reference.connect(func(ref:Player)->void: target = ref)
	grandparent.change_actions('Chase')
	grandparent.observer_null.connect(func(func_name): Observerton.match_null(self, func_name))


func player_out_of_sight()->void:
	pass

func player_spotted():
	pass
