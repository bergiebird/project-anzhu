## Static Hell
class_name L
extends Node

class Math:
	static func flip_a_coin()->bool:
		return Libraryton.rng.randi() % 2 == 1
class Palette:
	const BLACK :Color = Color("120e23")
	const BLUE_GRAY :Color = Color("6f6e72")
	const YELLOW_GRAY :Color = Color("aea47e")
	const SAND :Color = Color("ebb85b")
	const GOLD_DARK :Color = Color("c78539")
	const BROWN_LIGHT :Color = Color("a15c34")
	const BROWN_DARK :Color = Color("764032")
	const BROWN_DARKEST :Color = Color("402e2b")
	const GREEN_BLUE_LIGHT :Color = Color("6dba79")
	const BLUE_WATER_LIGHT :Color = Color("2a7d75")
	const BLUE_WATER_DARK :Color = Color("24505f")
	const BLUE_WATER_DARKEST :Color = Color("2a2942")
	const GREEN_BLUE_DARK :Color = Color("349c58")
	const GREEN_YELLOW :Color = Color("c9c03d")
	const GREEN_GRASS :Color = Color("7e9432")
	const GREEN_FOREST :Color = Color("56642e")
	const RED_ORANGE :Color = Color("e67146")
	const RED_TOMATO :Color = Color("b74132")
	const RED_BURGUNDY :Color = Color("7a2849")
	const PURPLE :Color = Color("3a1b40")
	const PINK_LIGHT :Color = Color("e67a84")
	const PINK_DARK :Color = Color("c23753")
	const WHITE_YELLOW :Color = Color("fff1a9")
	const WHITE_WHITE :Color = Color("eaf1f0")
class BasicPalette:
	const BASIC_WHITE_TRANSPARENT :Color = Color("ffffff00")
	const BASIC_WHITE :Color = Color("ffffff")
	const BASIC_BLACK :Color = Color('000000')
class Beings: # Send this to a resource
	enum Speed{CREEP, WALK, JOG, RUN}
	const INFO :Dictionary[String,Dictionary] = {
		"Walrus": {
			"Icon": "uid://cnal7mdp3mmck",
			"StartingHealth": 8,
			"DamagePerHit":1,
			"SpeedType": {
				"Creep": 100,   # Creeep for all characters needs to be given a purpose
				"Walk": 500,
				"Jog": 600,
				"Run": 700,
				},
			},
		"Owl": {
			"Icon": "uid://71j8kiflxsk2",  # needs unique icon
			"StartingHealth": 8,
			"DamagePerHit":1,
			"SpeedType": {
				"Creep": 0,
				"Walk": 0,
				"Jog": 0,
				"Run": 0,
				},
			},
		"Human": {
			"Icon": "uid://b5w8irxl1q86d",
			"StartingHealth": 8,
			"DamagePerHit":1,
			"SpeedType": {
				"Creep": 10,
				"Walk": 700,
				"Jog": 1000,
				"Run": 2000,
				},
			},
		"Bear": {
			"Icon": "uid://biih26xvgaec6",
			"StartingHealth": 12,  # These guys are TANKS
			"DamagePerHit":1,
			"SpeedType": {
				"Creep": 10,
				"Walk": 500, # Make very slow so player can get far away, half speed of jog
				"Jog": 1225,
				"Run": 2700,
				},
			},
		"Fox":{
			"Icon": "uid://71j8kiflxsk2",
			"StartingHealth": 8,
			"DamagePerHit":1,
			"SpeedType": {
				"Creep": 0,
				"Walk": 0,
				"Jog": 0,
				"Run": 0,
				},
			},
		"Hare":{
			"Icon": "uid://71j8kiflxsk2", # needs unique icon
			"StartingHealth": 8,
			"DamagePerHit":1,
			"SpeedType": {
				"Creep": 0,
				"Walk": 0,
				"Jog": 0,
				"Run": 0,
				},
			},
		"Wolf":{
			"Icon": "uid://d11nkbyklfwt6",
			"StartingHealth": 8,
			"DamagePerHit":1,
			"SpeedType": {
				"Creep": 0,
				"Walk": 0,
				"Jog": 0,
				"Run": 0,
				},
			},
		"Deer":{
			"Icon": "uid://1lv1vg0ga3o",
			"StartingHealth": 8,
			"DamagePerHit":1,
			"SpeedType": {
				"Creep": 0,
				"Walk": 0,
				"Jog": 0,
				"Run": 0,
				},
			},
		"Mammoth":{
			"Icon": "uid://71j8kiflxsk2", # needs unique icon
			"StartingHealth": 8,
			"DamagePerHit":1,
			"SpeedType": {
				"Creep": 0,
				"Walk": 0,
				"Jog": 0,
				"Run": 0,
				},
			},
	}
class World:
#	enum Melatonin{Most,WhatIsThisSunYouSpeakOf,Great,MissingSun,Good,ItWillComeBack,Alright}
	const TOO_DARK_THRESHOLD :float = 0.025
	const TIME :Dictionary = {
		"Dawn": {
			"modulate": 0.67,
			"modulate_duration":1,
			"next_time": "Morning",
			"night_lights_on": false,
			"camp_fire_energy":0.30,
#			"melatonin_value": Melatonin.Alright,
		},
		"Morning": {
			"modulate": 0.98,
			"modulate_duration":1,
			"next_time": "Noon",
			"night_lights_on": false,
			"camp_fire_energy":0.20,
#			"melatonin_value": Melatonin.Good,
		},
		"Noon": {
			"modulate": 1.00,
			"modulate_duration":1,
			"next_time": "Afternoon",
			"night_lights_on": false,
			"camp_fire_energy":0.10,
#			"melatonin_value": Melatonin.Great,
		},
		"Afternoon": {
			"modulate": 0.98,
			"modulate_duration":1,
			"next_time": "Dusk",
			"night_lights_on": false,
			"camp_fire_energy":0.11,
#			"melatonin_value": Melatonin.Most,
		},
		"Dusk": {
			"modulate": 0.67,
			"modulate_duration":1,
			"next_time": "Night",
			"night_lights_on": false,
			"camp_fire_energy":0.30,
#			"melatonin_value": Melatonin.Alright,
		},
		"Night": {
			"modulate": 0.40,
			"modulate_duration":1,
			"next_time": "Midnight",
			"night_lights_on": true,
			"camp_fire_energy":0.40,
#			"melatonin_value": Melatonin.MissingSun,
		},
		"Midnight": {
			"modulate": 0.33,
			"modulate_duration":1,
			"next_time": "Late Night",
			"night_lights_on": true,
			"camp_fire_energy":0.50,
#			"melatonin_value": Melatonin.WhatIsThisSunYouSpeakOf,
		},
		"Late Night": {
			"modulate": 0.40,
			"modulate_duration":1,
			"next_time": "Dawn",
			"night_lights_on": true,
			"camp_fire_energy":0.60,
#			"melatonin_value": Melatonin.WhatIsThisSunYouSpeakOf,
		}
	}
class Tracking:
	enum Rotation {HORIZONTAL, VERTICAL}
	const ATLAS_OFFSET :Vector2i = Vector2i(1,1)
	const MAX_CELL_ARRAY_SIZE :int = 3
class Observe:

	## Each scene root contains the:
#	signal publish_event(String, Dictionary)

	## The subscriber is responsible with connecting to their scene root.
#		publish_event.connect(func(func_name:String, data:Variant=null):L.Observe.subscribe_to_event(self, func_name, data))

	## Use these function calls to connect to the publisher. Ensure to prefix it with parent, grandparent, etc.
	static func subscribe_to_event(target :Object, func_name :String, data: Variant):
		if data or data is bool:
			if target.has_method(func_name):
				Callable(target, func_name).call(data)
		elif target.has_method(func_name):
			Callable(target, func_name).call()
