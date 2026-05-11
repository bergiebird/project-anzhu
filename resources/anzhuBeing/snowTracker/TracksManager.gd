extends CanvasGroup
class_name TracksManager


## The higher the number, the longer itll take for tracks to disappear
@export var mod_tracks_amount: float = 100.0

@onready var new_tracks: Array[TileMapLayer] = []
@onready var tracks_being_weathered: Array[TileMapLayer] = []
@onready var tweens: Array[Tween] = []
@onready var storm_timer: Timer = $StormTimer
@onready var blend_track_timer: Timer = $BlendTrackTimer


func _ready() -> void:
	Sgnl.reference_emitter_deferred("tracks_reference", self)
	Sgnl.new_weather.connect(_on_new_weather)
	blend_track_timer.timeout.connect(_on_blend_track_timer_timeout)
	storm_timer.timeout.connect(_on_storm_timer_timeout)


func _on_storm_timer_timeout() -> void:
	blend_track_timer.start()
	_duplicate_new_tracks()
	_modulate_tracks()


func _on_blend_track_timer_timeout() -> void:
	_duplicate_new_tracks()
	_modulate_tracks()


func _on_new_weather(how_much_snow: float, how_fast_snow_moves: float) -> void:
	var new_wait_time: float = how_much_snow * (how_fast_snow_moves + 1.0) * mod_tracks_amount
	_clean_tweens()
	if new_wait_time <= 0.0:
		storm_timer.stop()
		blend_track_timer.stop()
	else:
		storm_timer.start(new_wait_time)
		blend_track_timer.start()
		_init_new_tracks()
		_duplicate_new_tracks()
		_modulate_tracks()


func _init_new_tracks() -> void:
	if new_tracks.size() == 0:
		for child: Node in get_children():
			if child is TileMapLayer:
				new_tracks.append(child)


func _duplicate_new_tracks() -> void:
	for track: TileMapLayer in new_tracks:
		var new_weathered_track: TileMapLayer = track.duplicate()
		add_child(new_weathered_track)
		tracks_being_weathered.append(new_weathered_track)
		track.clear()


func _modulate_tracks() -> void:
	if tracks_being_weathered.size():
		var to_be_removed: Array[TileMapLayer]
		for track: TileMapLayer in tracks_being_weathered:
			if track.modulate.a <= 0.0:
				to_be_removed.append(track)
				track.queue_free()
			else:
				var tween: Tween = create_tween()
				tweens.append(tween)
				tween.tween_property(track, ^"modulate:a", 0.0, storm_timer.wait_time)
		if to_be_removed:
			for track: TileMapLayer in to_be_removed:
				tracks_being_weathered.erase(track)


func _clean_tweens() -> void:
	if tweens:
		for tween: Tween in tweens:
			tween.kill()
		tweens.clear()
