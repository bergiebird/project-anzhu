extends TileMapLayer # Props.gd
# Should be a resource in a later stage maybe
enum EdiblePlantType{SHRUB, BERRY, HERB, FUNGI}
var plant_encyclopedia :Dictionary = {
	"Arc Willow":
	# The tallest tree and most abundant plant.
	# Place: protected coastlines.
	{
		"EdiblePlantType": EdiblePlantType.SHRUB,
	},
	"Saxifraga":
	# Place: gravelly areas, near coastlines, and on rocks.
	{
		"EdiblePlantType": EdiblePlantType.SHRUB,
	},
	"Arc Cotton Grass":
	# Place: wet coastal depressions, near walrus haulouts
	{
		"EdiblePlantType": EdiblePlantType.HERB,
		"Eaten By": [Reindeer]
	},
	"Arc Chick Weed":
	# Near Coastal rocks and fox hunting grounds.
	{
		"EdiblePlantType": EdiblePlantType.HERB
	},
	"Peat Moss":
	# Place: lowlands, in extensive patches.
	# Should surround fox dens.
	{
		"EdiblePlantType": EdiblePlantType.FUNGI
	},
	"Sedges":
	# Place: lowlands, in clumps
	{
		"EdiblePlantType": EdiblePlantType.SHRUB
	},
	"Arc Gentian":
	# Place: Slightly raised areas, wet areas.
	{
		"EdiblePlantType": EdiblePlantType.HERB
	},
	"Rusulla":
	# Place: lowland
	{
		"EdiblePlantType": EdiblePlantType.FUNGI
	},
	"Snow Algae":
	# Place: lowland
	{
		"EdiblePlantType": EdiblePlantType.FUNGI
	},
	"Bearberry":
	# Place: Dry upland
	{
		"EdiblePlantType": EdiblePlantType.BERRY
	},
	"Crowberry":
	# Place: Dry upland, near fox dens
	{
		"EdiblePlantType": EdiblePlantType.BERRY
	},
	"Dwarf Shrubs":
	# Place: Sheltered areas
	# Hare Gathering
	{
		"EdiblePlantType": EdiblePlantType.SHRUB,
		"Eaten By": [Hare]
	},
	"Arc Bell Heather":
	# Place: Sheltered areas
	# Hare Gathering
	{
		"EdiblePlantType": EdiblePlantType.HERB,
		"Eaten By": [Hare]
	},
	"Reindeer Lichen":
	# Place: Sheltered areas
	{
		"EdiblePlantType": EdiblePlantType.FUNGI,
		"Eaten By": [Reindeer]
	},
	"Iceland Moss":
	# Place: Sheltered areas
	{
		"EdiblePlantType": EdiblePlantType.FUNGI
	},
	"Map Lichen":
	# Place: Near & on rocks
	{
		"EdiblePlantType": EdiblePlantType.FUNGI
	},
	"Cushion Plant":
	{
		"EdiblePlantType": EdiblePlantType.FUNGI
	},
}

func _ready() -> void:
	Libraryton.reference_emitter_deferred("props_reference", self, debug)

###
## DEBUG
###
@export var debug:bool = false
