extends CanvasGroup #Entities.gd

func _ready() -> void:
	Libraryton.reference_emitter_deferred("entities_reference", self, debug)


###
##	DEBUG
###
@export var debug:bool = false
