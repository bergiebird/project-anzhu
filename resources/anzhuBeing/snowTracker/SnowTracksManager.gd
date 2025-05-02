extends CanvasGroup #Tracks.gd

func _ready() -> void:
	Libraryton.reference_emitter_deferred("tracks_reference", self, debug)

## To Be Used: With Storms
func cover_tracks(_map_ :TileMapLayer)->void:
	var covering_tween :Tween = create_tween()
	Debuggerton.tweener_property_disposal([
		covering_tween.tween_property(_map_, "modulate", Swatchton.BASIC_WHITE_TRANSPARENT, 10.0)
	], debug)
	Debuggerton.signal_checker([
		covering_tween.finished.connect(func()->void: _map_.clear())
	], debug)

###
##	DEBUG
###
@export var debug :bool = false
