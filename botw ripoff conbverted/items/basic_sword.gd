extends CharacterBody3D
class_name swords

@export var col:NodePath=""
var type="sword"
var weopon_owner:StringName
@export var Damage:float = 5.0
@export var kb:float=30.0
var attack_multiplier=1.0
var Enemies_damaged=[]
func col_toggle(a:bool):
	
	get_node(col).disabled=not a
	
func swing(is_swing_start:bool,multiplier:float):
	
	attack_multiplier= multiplier if (is_swing_start) else 1.0 
		
	$Area3D.monitoring=is_swing_start
	clear()

func _ready():
	col_toggle(false)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_area_3d_body_entered(body):
	if weopon_owner == "":
		return
	if  not body in Enemies_damaged and ((body is enemies ) or (body is player and body.name != weopon_owner)):
		body.rpc("damage",Damage*attack_multiplier)
		print("Damage dealt: "+str(Damage))
		
		if "kb" in body:
			body.kb.dir=(body.position-get_parent().get_parent().get_parent().position).normalized()
			
			body.kb.mag=kb
	
		add_body(body)
		

func clear():
	Enemies_damaged=[]

func add_body(body):
	Enemies_damaged.append(body)
