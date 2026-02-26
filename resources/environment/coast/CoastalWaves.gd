extends AudioStreamPlayer2D
class_name _CoastalWaves

var player :Player
@onready var coastline :Line2D = get_parent()
@onready var line_points :PackedVector2Array = coastline.points
@onready var line_points_size: int = line_points.size()

func _ready()->void:
	coastline.default_color = L.BasicPalette.BASIC_WHITE_TRANSPARENT
	set_process(false)
	Sgnl.player_reference.connect(collect_player_reference)
	_debug()

func collect_player_reference(ref:Player):
	player = ref
	set_process(true)
	Sgnl.player_reference.disconnect(collect_player_reference)


func _process(_delta: float)->void:
	if player and coastline:
		global_position = find_closest_point_on_line(player.global_position)


func find_closest_point_on_line(point: Vector2)->Vector2:
	var closest_point: Vector2 = coastline.to_global(line_points[0])
	var closest_distance: float = point.distance_squared_to(closest_point)
	for index: int in range(1, line_points_size):
		var segment_start: Vector2 = coastline.to_global(line_points[index-1])
		var segment_end: Vector2 = coastline.to_global(line_points[index])
		var closest_on_segment: Vector2 = get_closest_point_on_segment(point, segment_start, segment_end)
		var distance: float = point.distance_squared_to(closest_on_segment)
		if distance < closest_distance:
				closest_distance = distance
				closest_point = closest_on_segment
	return closest_point

func get_closest_point_on_segment(point: Vector2, segment_start: Vector2, segment_end: Vector2)->Vector2:
	var segment: Vector2 = segment_end - segment_start
	var segment_length_squared: float = segment.length_squared()
	if segment_length_squared < 0.00001:
		return segment_start
	var projection: float = clamp(segment.dot(point - segment_start) / segment_length_squared, 0.0, 1.0)
	return segment_start + segment * projection

#region	DEBUG
@export_group('DEBUG')
@export var debug: bool = false
@onready var debug_image :Sprite2D = $DebugPosition

func _debug()->void:
	debug_image.visible = debug
#endregion
