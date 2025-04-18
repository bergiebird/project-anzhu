extends Node #Directon.gd
const ROTATE_NORTH :int = 270
const ROTATE_WEST :int = 180
const ROTATE_SOUTH :int = 90
const ROTATE_EAST :int = 0
var direction_keys :Array[Vector2i]
enum Looking{NORTH,SOUTH,EAST,WEST}
var looking_where :int = Looking.EAST
const DIRECTIONS :Array[String] = ["NORTH", "SOUTH", "EAST", "WEST"]
var directionary :Dictionary = {
	"NORTH": {
		"direction": Vector2i.UP,
		"jump": Vector2i.UP * 2,
		"enum": Looking.NORTH,
		"opposite": "SOUTH",
		"move_action": "move_NORTH",
		"aim": "aim_NORTH"
	},
	"SOUTH": {
		"direction": Vector2i.DOWN,
		"jump": Vector2i.DOWN * 2,
		"enum": Looking.SOUTH,
		"opposite": "NORTH",
		"move_action": "move_SOUTH",
		"aim": "aim_SOUTH",
	},
	"WEST": {
		"direction": Vector2i.LEFT,
		"jump": Vector2i.LEFT * 2,
		"enum": Looking.WEST,
		"opposite": "EAST",
		"move_action": "move_WEST",
		"aim": "aim_WEST",
		},
	"EAST": {
		"direction": Vector2i.RIGHT,
		"jump": Vector2i.RIGHT * 2,
		"enum": Looking.EAST,
		"opposite": "WEST",
		"move_action": "move_EAST",
		"aim": "aim_EAST",
		},
	}

func _ready() -> void:
	direction_keys = []
	for key in directionary.values():
		direction_keys.append(key['direction'])

func anim_wants_to_know_where_we_looking()->String:
	match looking_where:
		Looking.NORTH: return 'NORTH'
		Looking.EAST:  return 'EAST'
		Looking.WEST:  return 'WEST'
		Looking.SOUTH: return 'SOUTH'
		_:
			push_error('idk wtf happened here but your enum Looking fucked up')
			return '_'

func get_current_direction_data()->Dictionary:
	for direction in directionary:
		if directionary[direction]["enum"] == looking_where:
			return directionary[direction]
	push_error("Invalid looking_where value in Directon")
	return {}

func change_direction()->Vector2i:
	var new_direction :Vector2i = direction_keys[randi() % direction_keys.size()]
	get_stack()
	return new_direction

func get_player_direction(key2 :String)->Vector2i:
	return get_from_directionary(DIRECTIONS[looking_where], key2)

func get_from_directionary(key1, key2):
	return directionary[key1][key2]

func check_direction(direction)->bool:
	return DIRECTIONS.find(direction) == looking_where
