@tool extends TextureProgressBar

@onready var parent :CollisionShape2D = get_parent()
@onready var background :ColorRect = %Background
@onready var parent_size :int = round(parent.shape.get_rect().size.y)

@export var node_name :String:
	set(new_name):
		node_name = new_name
		if Engine.is_editor_hint():
			self.name = "StatBar_"+node_name
