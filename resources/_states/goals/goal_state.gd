class_name GoalState extends State #GoalState.gd

func goal_is_still_same()->bool:
	if grandparent.AnimalGoals.keys()[grandparent.current_goal] != self.name:
		return false
	else:
		return true
