extends AnimatedSprite2D #polar_bear_sprite.gd

enum PolarBearActions {Idle,Sit,Hit,Search,Chase}
var current_action :PolarBearActions
@onready var goals :Node = %Goals
@onready var hit :Node = $Hit
@onready var sit :Node = $Sit
@onready var idle :Node = $Idle
@onready var search :Node = $Search
@onready var chase :Node = $Chase

func process_idle()->void:
	play('Idle')

func process_sit()->void:
	play('Dit')

func process_hit()->void:
	play('Hit')
	unprocess_all()
	hit.start()

func process_search()->void:
	play('Move')

func process_chase()->void:
	play('Move')


func _ready()->void:
	unprocess_all()
func unprocess_all()->void:
	unprocess_idle()
	unprocess_sit()
	unprocess_hit()
	unprocess_search()
	unprocess_chase()
func unprocess_idle()->void:
	pass

func unprocess_sit()->void:
	pass

func unprocess_hit()->void:
	pass #may never be needed

func unprocess_search()->void:
	pass

func unprocess_chase()->void:
	pass
