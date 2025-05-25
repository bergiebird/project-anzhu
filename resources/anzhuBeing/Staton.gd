extends Node #Staton.gd

enum Speed{CREEP = 0, WALK = 1, JOG = 2, RUN = 3}
enum AnimalType {Walrus, Owl, Human,  Bear, Fox, Hare, Wolf, Reindeer, Mammoth}
const CHARACTER_SHEET :Dictionary[AnimalType,Dictionary] = {
	AnimalType.Walrus: {
		"Group": "Walrus",
		"Icon": "uid://cnal7mdp3mmck",
		"StartingHealth": 8,
		"DamagePerHit":1,
		"SpeedType": {
			Speed.CREEP: 100,   # Creeep for all characters needs to be given a purpose
			Speed.WALK: 500,
			Speed.JOG: 600,
			Speed.RUN: 700,
			},
		},
	AnimalType.Owl:{
		"Group": "Owl",
		"Icon": "uid://71j8kiflxsk2",  # needs unique icon
		"StartingHealth": 8,
		"DamagePerHit":1,
		"SpeedType": {
			Speed.CREEP: 0,
			Speed.WALK: 0,
			Speed.JOG: 0,
			Speed.RUN: 0,
			},
		},
	AnimalType.Human:{
		"Group": "Human",
		"Icon": "uid://b5w8irxl1q86d",
		"StartingHealth": 8,
		"DamagePerHit":1,
		"SpeedType": {
			Speed.CREEP: 10,
			Speed.WALK: 700,
			Speed.JOG: 1000,
			Speed.RUN: 2000,
			},
		},
	AnimalType.Bear:{
		"Group": "Bear",
		"Icon": "uid://biih26xvgaec6",
		"StartingHealth": 12,  # These guys are TANKS
		"DamagePerHit":1,
		"SpeedType": {
			Speed.CREEP: 10,
			Speed.WALK: 600, # Make very slow so player can get far away, half speed of jog
			Speed.JOG: 1400,  # Keep at 10% slower than player
			Speed.RUN: 2200, # Keep at 10% faster than player
			},
		},
	AnimalType.Fox:{
		"Group": "Fox",
		"Icon": "uid://71j8kiflxsk2",
		"StartingHealth": 8,
		"DamagePerHit":1,
		"SpeedType": {
			Speed.CREEP: 0,
			Speed.WALK: 0,
			Speed.JOG: 0,
			Speed.RUN: 0,
			},
		},
	AnimalType.Hare:{
		"Group": "Hare",
		"Icon": "uid://71j8kiflxsk2", # needs unique icon
		"StartingHealth": 8,
		"DamagePerHit":1,
		"SpeedType": {
			Speed.CREEP: 0,
			Speed.WALK: 0,
			Speed.JOG: 0,
			Speed.RUN: 0,
			},
		},
	AnimalType.Wolf:{
		"Group": "Wolf",
		"Icon": "uid://d11nkbyklfwt6",
		"StartingHealth": 8,
		"DamagePerHit":1,
		"SpeedType": {
			Speed.CREEP: 0,
			Speed.WALK: 0,
			Speed.JOG: 0,
			Speed.RUN: 0,
			},
		},
	AnimalType.Reindeer:{
		"Group": "Deer",
		"Icon": "uid://1lv1vg0ga3o",
		"StartingHealth": 8,
		"DamagePerHit":1,
		"SpeedType": {
			Speed.CREEP: 0,
			Speed.WALK: 0,
			Speed.JOG: 0,
			Speed.RUN: 0,
			},
		},
	AnimalType.Mammoth:{
		"Group": "Mammoth",
		"Icon": "uid://71j8kiflxsk2", # needs unique icon
		"StartingHealth": 8,
		"DamagePerHit":1,
		"SpeedType": {
			Speed.CREEP: 0,
			Speed.WALK: 0,
			Speed.JOG: 0,
			Speed.RUN: 0,
			},
		},
}
