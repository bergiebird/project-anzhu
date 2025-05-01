extends AudioStreamPlayer2D #CoastalWaves.gd
var player :Player:
	set(value): if player != value:
		player = value
		set_process(true)

@onready var coastline = get_parent()
@onready var line_points = coastline.points
@onready var line_points_size = line_points.size()

func _ready()->void:
	coastline.default_color = Swatchton.BASIC_WHITE_TRANSPARENT
	set_process(false)
	Libraryton.player_reference.connect(func(ref:Player): player = ref)
	_debug()

func _process(delta :float)->void:
	if player and coastline:
		global_position = find_closest_point_on_line(player.global_position)


func find_closest_point_on_line(point :Vector2)->Vector2:
	var closest_point = coastline.to_global(line_points[0])
	var closest_distance = point.distance_squared_to(closest_point)
	for index in range(1, line_points_size):
		var segment_start = coastline.to_global(line_points[index-1])
		var segment_end = coastline.to_global(line_points[index])
		var closest_on_segment = get_closest_point_on_segment(point, segment_start, segment_end)
		var distance = point.distance_squared_to(closest_on_segment)
		if distance < closest_distance:
				closest_distance = distance
				closest_point = closest_on_segment
	return closest_point

func get_closest_point_on_segment(point :Vector2, segment_start :Vector2, segment_end :Vector2)->Vector2:
	var segment = segment_end - segment_start
	var segment_length_squared = segment.length_squared()
	if segment_length_squared < 0.00001:
		return segment_start
	var projection = clamp(segment.dot(point - segment_start) / segment_length_squared, 0.0, 1.0)
	return segment_start + segment * projection

###
## DEBUG
###
@export_group('DEBUG')
@export var debug :bool = false
@onready var debug_image = $DebugPosition

func _debug()->void:
	if debug:
		debug_image.visible = true
	else:
		debug_image.visible = false
