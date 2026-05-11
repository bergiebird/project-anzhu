extends TileMapLayer
class_name Props

enum EdiblePlantType{SHRUB, BERRY, HERB, FUNGI} # Should be a resource in a later stage maybe

var plant_encyclopedia: Dictionary = {
	"Arc Willow":{
		"EdiblePlantType": EdiblePlantType.SHRUB,
		"Eaten By": [],
		"Description": "The tallest tree and most abundant plant.",
		"Placement":"Near protected coastlines",
	},
	"Saxifraga":{
		"EdiblePlantType": EdiblePlantType.SHRUB,
		"Eaten By": [],
		"Description":"",
		"Placement":"gravelly areas, near coastlines, and on rocks.",
	},
	"Arc Cotton Grass":{
		"EdiblePlantType": EdiblePlantType.HERB,
		"Eaten By": [Reindeer],
		"Description":"wet coastal depressions, near walrus haulouts",
		"Placement":"",
	},
	"Arc Chick Weed":{
		"EdiblePlantType": EdiblePlantType.HERB,
		"Eaten By": [],
		"Description":"",
		"Placement":" Near Coastal rocks and fox hunting grounds.",
	},
	"Peat Moss":{
		"EdiblePlantType": EdiblePlantType.FUNGI,
		"Eaten By": [],
		"Description":"",
		"Placement":"lowlands, in extensive patches. Should surround fox dens.",
	},
	"Sedges":{
		"EdiblePlantType": EdiblePlantType.SHRUB,
		"Eaten By": [],
		"Description":"",
		"Placement":"lowlands, in clumps",
	},
	"Arc Gentian":{
		"EdiblePlantType": EdiblePlantType.HERB,
		"Eaten By": [],
		"Description":"",
		"Placement":"Slightly raised areas, wet areas.",
	},
	"Rusulla":{
		"EdiblePlantType": EdiblePlantType.FUNGI,
		"Eaten By": [],
		"Description":"",
		"Placement":"lowland",
	},
	"Snow Algae":{
		"EdiblePlantType": EdiblePlantType.FUNGI,
		"Eaten By": [],
		"Description":"",
		"Placement": "lowland",
	},
	"Bearberry":{
		"EdiblePlantType": EdiblePlantType.BERRY,
		"Eaten By": [],
		"Description":"",
		"Placement":"Dry upland",
	},
	"Crowberry":{
		"EdiblePlantType": EdiblePlantType.BERRY,
		"Eaten By": [],
		"Description":"",
		"Placement":"Dry upland, near fox dens",
	},
	"Dwarf Shrubs":{
		"EdiblePlantType": EdiblePlantType.SHRUB,
		"Eaten By": [Hare],
		"Description":"Hare Gathering",
		"Placement":"Sheltered areas",
	},
	"Arc Bell Heather":{
		"EdiblePlantType": EdiblePlantType.HERB,
		"Eaten By": [Hare],
		"Description":"Hare Gathering",
		"Placement":"Sheltered areas",
	},
	"Reindeer Lichen":{
		"EdiblePlantType": EdiblePlantType.FUNGI,
		"Eaten By": [Reindeer],
		"Description":"",
		"Placement":"Sheltered areas",
	},
	"Iceland Moss":{
		"EdiblePlantType": EdiblePlantType.FUNGI,
		"Eaten By": [],
		"Description":"",
		"Placement":"Sheltered areas",
	},
	"Map Lichen":{
		"EdiblePlantType": EdiblePlantType.FUNGI,
		"Eaten By": [],
		"Description":"",
		"Placement":"Near & on rocks",
	},
	"Cushion Plant":{
		"EdiblePlantType": EdiblePlantType.FUNGI,
		"Eaten By": [],
		"Description":"",
		"Placement":"",
	},
}

func _ready():
	Sgnl.reference_emitter_deferred("props_reference", self, debug)

#region # DEBUG
@export var debug:bool = false
#endregion
