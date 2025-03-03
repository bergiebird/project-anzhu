@icon("res://warehouse/_icons/node_2D/icon_area_meteo.png")
extends CanvasModulate

@onready var day_night_system: DayNighton = DayNighton
@onready var timer_node: Timer = $WorldTimer
@onready var time_to_pass: int = int(timer_node.wait_time)

@export_enum("DAWN", "MORNING", "NOON", "AFTERNOON", "DUSK", "NIGHT", "MIDNIGHT", "LATE_NIGHT")
var time_right_before_start: int = day_night_system.TimeOfDay.LATE_NIGHT

@export_group('dawn')
@export var dawn_amount: int = 170
@export var dawn_lerp_time: float = 2
var init_dawn_lerp_time: int

@export_group('morning')
@export var morning_amount: int = 250
@export var morning_lerp_time: float = 0
var init_morning_lerp_time: int

@export_group('noon')
@export var noon_amount: int = 255
@export var noon_lerp_time: float = 0
var init_noon_lerp_time: int

@export_group('afternoon')
@export var afternoon_amount: int = 254
@export var afternoon_lerp_time: float = 0
var init_afternoon_lerp_time: int

@export_group('dusk')
@export var dusk_amount: int = 170
@export var dusk_lerp_time: float = 170
var init_dusk_lerp_time: int

@export_group('night')
@export var night_amount: int = 100
@export var night_lerp_time: float = 30
var init_night_lerp_time: int

@export_group('midnight')
@export var midnight_amount: int = 97
@export var midnight_lerp_time: float = 0
var init_midnight_lerp_time: int

@export_group('late_night')
@export var late_night_amount: int = 100
@export var late_night_lerp_time: float = 0
var init_late_night_lerp_time: int

var init_time_lerp: Array = []
var modulates_time_of_day_dictionary: Dictionary
var tween: Tween

func _ready() -> void:
	prepare_lerp_time()
	day_night_system.time_dictionary_delivery.connect(initialize_dictionary)
	day_night_system.initialize(self)
	day_night_system.time_progressed.connect(sun_change)
	day_night_system.progress_time(time_right_before_start)

func sun_change(new_time) -> void:
	print_rich("[color=#FFD700]⏰ Time has changed:[/color] [color=#87CEEB]" + modulates_time_of_day_dictionary[new_time]['name'] + "[/color]")
	var rgb_calculated: float = modulates_time_of_day_dictionary[new_time]['modulate']/255.0
	var target_color = Color(rgb_calculated, rgb_calculated, rgb_calculated)
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, 'color', target_color, modulates_time_of_day_dictionary[new_time]['modulate_duration'])

func prepare_lerp_time() -> void:
	# Initialize the array with correct size
	init_time_lerp.resize(day_night_system.TimeOfDay.size())

	# Map each time to its respective lerp value
	var lerp_times = [dawn_lerp_time, morning_lerp_time, noon_lerp_time, afternoon_lerp_time,
					  dusk_lerp_time, night_lerp_time, midnight_lerp_time, late_night_lerp_time]

	for i in range(lerp_times.size()):
		if lerp_times[i] <= 1:
			init_time_lerp[i] = 1
		else:
			init_time_lerp[i] = int(time_to_pass/lerp_times[i])

func initialize_dictionary(incoming_delivery: Dictionary) -> void:
	modulates_time_of_day_dictionary = incoming_delivery
