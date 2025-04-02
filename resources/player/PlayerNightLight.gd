extends PointLight2D #PlayerNightLight.gd
@onready var timer :Timer = $Timer
@export var debug_night_light = false
@export var minimum_energy :float = 0.06
@export var maximum_energy :float = 0.17
@export var time_until_off :float = 35.0
@export var time_until_on :float = 40.0
var node_dictionary :Dictionary[String, Node] = {}:
	set(new_dictionary):
		node_dictionary = new_dictionary
var time_dictionary :Dictionary
var tween_energy_up :Tween
var tween_energy_down :Tween

func _ready()->void:
	DayNighton.turn_on_night_lights.connect(update_nightlight)
	Signalton.gunshot.connect(gunshot_sequence)
	timer.timeout.connect(starting_to_see_again)
	energy = minimum_energy

func dictionary_inbox(incoming_delivery :Dictionary)->void:
	time_dictionary = incoming_delivery

func update_nightlight(on_off :bool)->void:
	if visible == true and on_off == false:
		turn_off_nightlight()
	elif visible == false and on_off == true:
		turn_on_nightlight()

func turn_on_nightlight()->void:
	visible = true
	starting_to_see_again()

func turn_off_nightlight()->void:
	cant_see_anything(time_until_off)
	await get_tree().create_timer(time_until_off).timeout
	visible = false

func cant_see_anything(floater:float = 0.2)->void:
	if visible == true:
		if tween_energy_down and tween_energy_down.is_valid():
			tween_energy_down.kill()
		if tween_energy_up and tween_energy_up.is_valid():
			tween_energy_up.kill()
		tween_energy_down = create_tween()
		tween_energy_down.tween_property(self, 'energy', minimum_energy, floater).set_trans(Tween.TRANS_EXPO)

func starting_to_see_again()->void:
	if visible == true:
		if tween_energy_down and tween_energy_down.is_valid():
			tween_energy_down.kill()
		if tween_energy_up and tween_energy_up.is_valid():
			tween_energy_up.kill()
		tween_energy_up = create_tween()
		tween_energy_up.tween_property(self, 'energy', maximum_energy, time_until_on).set_trans(Tween.TRANS_CIRC)

func gunshot_sequence()->void:
	cant_see_anything()
	timer.start()

func campfire_nightlight(is_leaving_campfire :bool)->void:
	if is_leaving_campfire:
		starting_to_see_again()
	else:
		cant_see_anything(3.0)

func debug()->void:
	print_rich('[color=2a2942]NightLight debugging enabled . . .[/color]')
	debug_night_light = true
