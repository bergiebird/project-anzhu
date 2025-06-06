@icon("res://resources/anzhuBeing/anzhuAnimal/hare/Hare.png")
class_name Hare extends AnzhuAnimal





#region    #=======================================# DEBUG
func early_ready_for_debug()->void:
	if debug_self:
		debug_icon = "[img]res://resources/fox/fox.png[/img]"
		print_rich(debug_icon)
#endregion #=======================================# DEBUG
