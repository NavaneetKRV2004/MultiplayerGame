extends RigidBody3D


@export var col:NodePath=""
var type="sword"
var damage = 5

func col_toggle(a:bool):
	
	get_node(col).disabled=not a
	
func _ready():
	print(get_parent())
	position=get_parent().global_position
	rotation=get_parent().rotation
func _physics_process(delta):
	global_position=get_parent().global_position
	rotation_degrees=get_parent().rotation_degrees
	
