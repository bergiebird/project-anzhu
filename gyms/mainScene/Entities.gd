extends CanvasGroup
class_name Entities

func _ready():
	Libraryton.reference_emitter_deferred("entities_reference", self, debug)

#region    #=========================================# DEBUG
@export var debug:bool = false
#endregion #=========================================# DEBUG
