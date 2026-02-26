extends Node #Directon.gd

enum Looking{NORTH,SOUTH,EAST,WEST} #problem child TODO
#var looking_where: int = Looking.EAST #problem child

const SIZE: int = 4
const DIRECTIONS: Array[String] = [               "NORTH",           "SOUTH",             "EAST",             "WEST"]
const ENUM_POS: Dictionary[String,int] = {     "NORTH": 0,         "SOUTH":1,           "EAST":2,           "WEST":3}
const ANIM_NAME: Array[String] = [               "_NORTH",          "_SOUTH",            "_SIDE",            "_SIDE"]
const MOVE_ACTION: Array[String] = [         "move_NORTH",      "move_SOUTH",        "move_EAST",        "move_WEST"]
const AIM_ACTION: Array[String] = [           "aim_NORTH",       "aim_SOUTH",         "aim_EAST",         "aim_WEST"]
const OPPOSITE:Dictionary[String,String]={"NORTH":"SOUTH",   "SOUTH":"NORTH",      "EAST":"WEST",      "WEST":"EAST"}
const SHOULD_FLIP_H: Array[bool] = [                false,             false,              false,               true]
const HEAD_COVERING: Array[int] = [                    -1,                 0,                  0,                  0]
const ROTATE: Array[int] = [                          270,                90,                  0,                180]
const VECTORS: Array[Vector2i] = [            Vector2i.UP,     Vector2i.DOWN,     Vector2i.RIGHT,      Vector2i.LEFT]
const GUN_POSITION: Array[Vector2] = [  Vector2(1.5,-6.0), Vector2(-1.5,2.0),   Vector2(5.5,-1.5), Vector2(-5.0,-1.5)]
const SMOKE_POSITION: Array[Vector2] = [ Vector2(0.0,2.0), Vector2(0.0,-4.0), Vector2(-5.0, -1.25), Vector2(4.0, -0.75)]
const GUN_Z_INDEX: Array[int]= [                        1,                 2,                   2,                 2]

func get_vectors(direction:int)->Vector2i:
	return VECTORS[direction]
func get_vectors_with_string(direction:String)->Vector2i:
	return VECTORS[ENUM_POS[direction]]
func get_aim(direction: String)->String:
	return AIM_ACTION[ENUM_POS[direction]]
func get_personal_should_flip(direction: String)->bool:
	return SHOULD_FLIP_H[ENUM_POS[direction]]

func get_personal_anim_direction(enum_pos: String)->String:
	return ANIM_NAME[ENUM_POS[enum_pos]]
func get_current_direction(direction: int)->String:
	return DIRECTIONS[direction]
func jump_distance_calculation(distance: int, direction:int)->Vector2i:
	return VECTORS[direction] * distance

func gunmatch(who :Gunshot, smoke_barrel :CPUParticles2D, smoke_back :CPUParticles2D, gunray: RayCast2D, direction: int):
	gunray.rotation_degrees = ROTATE[direction]
	who.position = GUN_POSITION[direction]
	smoke_barrel.direction = VECTORS[direction]
	smoke_back.position = SMOKE_POSITION[direction]

func get_prevalent_direction(vector: Vector2)->int:
	var degrees: float = rad_to_deg(vector.angle())
	if degrees < 0: degrees += 360
	if degrees >= 315 or degrees < 45:
		return Looking.EAST
	elif degrees >= 45 and degrees < 135:
		return Looking.SOUTH
	elif degrees >= 135 and degrees < 225:
		return Looking.WEST
	else:
		return Looking.NORTH

func choose_random_direction()->Vector2i:
	return VECTORS[ENUM_POS[DIRECTIONS[randi() % SIZE]]]

func get_DIRECTION_via_VECTOR(vector: Vector2)->int:
	return get_prevalent_direction(vector)
