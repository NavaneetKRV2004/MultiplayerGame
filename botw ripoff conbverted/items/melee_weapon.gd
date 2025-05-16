extends Node


@export var col:NodePath=""
var type="sword"
var weapon_owner:StringName
@export var damage:float = 5.0
@export var knockback:float=30.0
var attack_multiplier=1.0
var enemies_damaged=[]

func col_toggle(a:bool):
	
	get_node(col).disabled=not a
	
func swing(is_swing_start:bool,multiplier:float):
	
	attack_multiplier= multiplier if (is_swing_start) else 1.0 
		
	$Area3D.monitoring=is_swing_start
	memory_clear()

func _ready():
	col_toggle(false)
	

func _on_area_3d_body_entered(body):
	if weapon_owner == "":
		return
	if  not body in enemies_damaged and ((body is enemies ) or (body is player and body.name != weapon_owner)):
		body.rpc("damage",damage*attack_multiplier)
		print("Damage dealt: "+str(damage))
		
		if "kb" in body:
			body.kb.dir=(body.position-get_parent().get_parent().get_parent().position).normalized()
			
			body.kb.mag=knockback
	
		add_body_to_memory(body)
		

func memory_clear():
	enemies_damaged=[]

func add_body_to_memory(body):
	enemies_damaged.append(body)
