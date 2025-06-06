extends CanvasGroup
class_name TracksManager

@export var debug: bool = false
@onready var all_maps :Array[TileMapLayer]
@onready var tim :Timer = $three
func _ready():
	Signalton.reference_emitter_deferred("tracks_reference", self, debug)
	#tim.timeout.connect(age_all_maps)
	call_deferred("get_all_maps")

func get_all_maps():
	for child in get_children():
		if child is TileMapLayer:
			all_maps.append(child)

#
#func age_all_maps():
	#for map in all_maps:
		#for cell in map.get_used_cells():
			#var data = map.get_cell_tile_data(cell)
			#print(data)
			#var dataa = data.get_modulate() - Color(0,0,0,0.01)
			#data.set_modulate(dataa)







# For storms, later
#func cover_tracks(_map_: TileMapLayer):
	#var covering_tween: Tween = create_tween()
	#Debuggerton.tweener_property_disposal([
		#covering_tween.tween_property(_map_, "modulate",L.Palette.BASIC_WHITE_TRANSPARENT, 10.0)], debug)
	#covering_tween.finished.connect(func() -> void: _map_.clear())
