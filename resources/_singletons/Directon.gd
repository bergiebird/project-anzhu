extends Node #Directon.gd

enum Looking{NORTH,SOUTH,EAST,WEST}
var looking_where :int = Looking.EAST
var direction_priority :Array[String] = ["NORTH", "SOUTH", "WEST", "EAST"]
var character_directions_bible :Dictionary = {
	"NORTH": {
		"vector": Vector2(0, -1),
		"jump": Vector2i(0,-2),
		"enum": Looking.NORTH,
		"opposite": "SOUTH",
		"move_action": "move_NORTH",
		"aim_action": "aim_NORTH"
	},
	"SOUTH": {
		"vector": Vector2(0, 1),
		"jump": Vector2i(0,2),
		"enum": Looking.SOUTH,
		"opposite": "NORTH",
		"move_action": "move_SOUTH",
		"aim_action": "aim_SOUTH",
	},
	"WEST": {
		"vector": Vector2(-1, 0),
		"jump": Vector2i(2,0),
		"enum": Looking.WEST,
		"opposite": "EAST",
		"move_action": "move_WEST",
		"aim_action": "aim_WEST",
		},
	"EAST": {
		"vector": Vector2(1, 0),
		"jump": Vector2i(-2,0),
		"enum": Looking.EAST,
		"opposite": "WEST",
		"move_action": "move_EAST",
		"aim_action": "aim_EAST",
		},
	}

func anim_wants_to_know_where_we_looking()->String:
	match looking_where:
		Looking.NORTH: return '_NORTH'
		Looking.EAST:  return '_EAST'
		Looking.WEST:  return '_WEST'
		Looking.SOUTH: return '_SOUTH'
		_:
			push_error('idk wtf happened here but your enum Looking fucked up')
			return '_'

func get_current_direction_data()->Dictionary:
	for direction in character_directions_bible:
		if character_directions_bible[direction]["enum"] == looking_where:
			return character_directions_bible[direction]
	push_error("Invalid looking_where value in Directon")
	return {}
