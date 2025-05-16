extends CharacterBody3D
class_name shield

@export var protection=10
@export var col:NodePath

func col_toggle(a:bool):
	get_node(col).disabled=not a

func _ready():
	pass
