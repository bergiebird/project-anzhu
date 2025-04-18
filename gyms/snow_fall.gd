@icon("res://warehouse/icons/node/icon_gear.png")
class_name SnowFall extends GPUParticles2D #SnowFall.gd

@export_group('Weather Control')
enum FrequencyType{BLIZZARD,SQUALL, NORMAL,DUSTING, NONE}
enum WindDirection{NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST}
enum WindSpeed{BLIZZARD,SQUALL,GALE,STRONGBREEZE,MODERATEBREEZE,LIGHTBREEZE,CALM,}
## This establishes how many particles are on screen. It simply reduces the spawn radius for severe storms and increases the radius for more calm effects. - BERGIE
@export_enum("Blizzard","Squall", "Normal", "Dusting", "None") var frequency :int = 0:
	set(value):
		if value != frequency:
			var old_value = frequency
			frequency = value
			update_frequency(value, old_value)
@export_enum("North","NorthEast","East","SouthEast","South","SouthWest","West","NorthWest") var direction :int = 0:
	set(value):
		if value != direction:
			var old_value = direction
			direction = value
			update_direction(value, old_value)
@export_enum("Blizzard", "Squall","Gale","StrongBreeze","ModerateBreeze","LightBreeze","Calm") var speed :int = 0:
	set(value):
		if value != speed:
			var old_value = speed
			speed = value
			update_speed(value, old_value)
var frequencies :Dictionary[int,float] = {FrequencyType.BLIZZARD:200.0,
														FrequencyType.SQUALL  :300.0,
														FrequencyType.NORMAL  :700.0,
														FrequencyType.DUSTING :2000.0,
														FrequencyType.NONE    :12000.0,}
var directions :Dictionary[int,Vector3] = { WindDirection.NORTH     :Vector3.DOWN,
															WindDirection.NORTHEAST :Vector3.DOWN + Vector3.RIGHT,
															WindDirection.EAST      :Vector3.RIGHT,
															WindDirection.SOUTHEAST :Vector3.UP + Vector3.RIGHT,
															WindDirection.SOUTH     :Vector3.UP,
															WindDirection.SOUTHWEST :Vector3.UP + Vector3.LEFT,
															WindDirection.WEST      :Vector3.LEFT,
															WindDirection.NORTHWEST :Vector3.DOWN + Vector3.LEFT,}
var speeds :Dictionary[int, int] = { WindSpeed.BLIZZARD      :128,
												 WindSpeed.SQUALL        :64,
												 WindSpeed.GALE          :48,
												 WindSpeed.STRONGBREEZE  :32,
												 WindSpeed.MODERATEBREEZE:16,
												 WindSpeed.LIGHTBREEZE   :8,
												 WindSpeed.CALM          :4,
												}
var wind_direction :Vector2
@onready var sfx_wind :AudioStreamPlayer2D = $WindSFX
@onready var parent :Camera2D = get_parent()

func _ready() -> void:
	Libraryton.reference_emitter_deferred("snowfall_reference", self)
	update_frequency(frequency, frequency)
	update_direction(direction, direction)
	update_speed(speed, speed)
	if not Engine.is_editor_hint():
		sfx_wind.call_deferred("play")

func update_frequency(val :int, old_val:int)->int:
	var ftween_time = abs(val-old_val)
	if frequency == 5: emitting = false
	else:              emitting = true
	Builderton.tweener(process_material, "emission_sphere_radius", frequencies[val], ftween_time)
	call_deferred("position_wind_sfx", ftween_time)
	return val

func update_direction(val :int, old_val:int)->int:
	var dtween_time = abs(val-old_val)
	Builderton.tweener(process_material, "direction", directions[val], dtween_time)
	wind_direction = Vector2(directions[val].x, directions[val].y)
	call_deferred("position_wind_sfx", dtween_time)
	return val

func update_speed(val :int, old_val:int)->int:
	var stween_time = abs(val-old_val)
	Builderton.tweener(process_material, "linear_accel_min", speeds[val],stween_time)
	Builderton.tweener(process_material, "linear_accel_max", speeds[val],stween_time)
	call_deferred("position_wind_sfx", stween_time)
	return val

func position_wind_sfx(tween_time)->void:
	var position_new = parent.position - wind_direction*((speed*speed*speed+10))*10
	var pitch_new = 1.4 - (float(frequency)*0.1)
	Builderton.tweener(sfx_wind, "pitch_scale", pitch_new,tween_time)
	Builderton.tweener(sfx_wind, "position", position_new,tween_time)
