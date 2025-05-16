extends CharacterBody3D
class_name bows

@export var damage:float
@export var withdraw_speed:float
@export var anim:NodePath
@export var col:NodePath

@export var withdraw_completion:float=0
func withdraw(s):
	get_node(anim).play("withdraw",-1,s)
func release(s):
	get_node(anim).play("release",-1,s)
	
func col_toggle(a:bool):
	
	get_node(col).disabled=not a
	
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
