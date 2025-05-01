extends Node #Directon.gd

enum Looking{NORTH,SOUTH,EAST,WEST}
var looking_where :int = Looking.EAST
const SIZE :int = 4
const DIRECTIONS :Array[String] = [                "NORTH",           "SOUTH",             "EAST",             "WEST"]
const ENUM_POS :Dictionary[String,int] = {      "NORTH": 0,         "SOUTH":1,           "EAST":2,           "WEST":3}
const ANIM_NAME :Array[String] = [                "_NORTH",          "_SOUTH",            "_SIDE",            "_SIDE"]
const MOVE_ACTION :Array[String] = [          "move_NORTH",      "move_SOUTH",        "move_EAST",        "move_WEST"]
const AIM_ACTION :Array[String] = [            "aim_NORTH",       "aim_SOUTH",         "aim_EAST",         "aim_WEST"]
const OPPOSITE:Dictionary[String,String]= {"NORTH":"SOUTH",   "SOUTH":"NORTH",      "EAST":"WEST",      "WEST":"EAST"}
const SHOULD_FLIP_H :Array[bool] = [                 false,             false,              false,               true]
const ROTATE :Array[int] = [                           270,                90,                  0,                180]
const VECTORS :Array[Vector2i] = [             Vector2i.UP,     Vector2i.DOWN,      Vector2i.RIGHT,     Vector2i.LEFT]
const GUN_POSITION :Array[Vector2] = [   Vector2(0.5,-4.0), Vector2(-1.5,3.0),   Vector2(4.0,0.5), Vector2(-4.0,-0.5)]
const SMOKE_POSITION :Array[Vector2] = [      Vector2.DOWN, Vector2(3.0, 0.0), Vector2(0.0, -5.0), Vector2(-3.0, 0.0)]

func get_vectors(direction:int)->Vector2i:                        return VECTORS[direction]
func get_vectors_with_string(direction:String)->Vector2i:         return VECTORS[ENUM_POS[direction]]
func get_aim(direction)->String:                                  return AIM_ACTION[ENUM_POS[direction]]
func get_should_flip()->bool:                                     return SHOULD_FLIP_H[looking_where]
func change_direction()->String:                                  return DIRECTIONS[randi() % SIZE]
func get_anim_direction()->String:                                return ANIM_NAME[looking_where]
func get_current_direction(direction :int=looking_where)->String: return DIRECTIONS[direction]
func check_direction(direction :String)->bool:                    return DIRECTIONS.find(direction) == looking_where
func jump_distance_calculation(distance :int)->Vector2i:          return VECTORS[looking_where] * distance
func set_direction(direction:String)->void:                              looking_where = ENUM_POS[direction]

func match_current_direction(direction:String, north:Callable, south:Callable, east:Callable, west:Callable)->bool:
	match ENUM_POS[direction]:
		Looking.NORTH:  north.call()
		Looking.SOUTH:  south.call()
		Looking.EAST:   east.call()
		Looking.WEST:   west.call()
		_: return false
	return true


func gunmatch(who, smoke_barrel,smoke_back,gunray)->void:
	gunray.rotation_degrees = ROTATE[looking_where]
	who.position = GUN_POSITION[looking_where]
	smoke_barrel.direction = VECTORS[looking_where]
	smoke_back.position = SMOKE_POSITION[looking_where]

func get_prevalent_direction(vector :Vector2)->int:
	var degrees :float = rad_to_deg(vector.angle())
	if degrees < 0: degrees += 360
	if degrees >= 315 or degrees < 45:     return Looking.EAST
	elif degrees >= 45 and degrees < 135:  return Looking.SOUTH
	elif degrees >= 135 and degrees < 225: return Looking.WEST
	else:                                  return Looking.NORTH


func get_DIRECTION_via_VECTOR(vector :Vector2)->String:
	return get_current_direction(get_prevalent_direction(vector))
