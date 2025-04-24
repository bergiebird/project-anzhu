extends PointLight2D #PlayerNightLight.gd

@export var minimum_light :float = 0.06
@export var maximum_light :float = 0.17
@export var fast_time :float = 0.1
@export var slow_time :float = 35.0
@onready var timer_node :Timer = $Timer
@onready var abilities :Abilities = get_parent().get_node('Abilities')

func _ready()->void:
	DayNighton.turn_on_night_lights.connect(update_nightlight)
	abilities.gunfired.connect(func(bol): if bol: change_nightlight(minimum_light, fast_time))
	timer_node.timeout.connect(func(): visible = false)
	energy = minimum_light

func update_nightlight(should_nightlight_be_on :bool)->void:
	if should_nightlight_be_on:
		if not visible:
			change_nightlight(maximum_light, slow_time)
	else:
		if visible:
			change_nightlight(minimum_light, slow_time)

func change_nightlight(m_energy, wait_time)->void:
	Builderton.tweener_deferred(self, 'energy', m_energy, wait_time, Tween.TRANS_EXPO)
	if not visible:
		visible = true
	if m_energy == minimum_light:
		timer_node.wait_time = wait_time
		timer_node.start()


###
## DEBUG
###
@export_group("DEBUG")
@export var debug_night_light = false
func debug()->void:
	print_rich('[color=2a2942]NightLight debugging enabled . . .[/color]')
	debug_night_light = true
