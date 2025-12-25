extends items
class_name swords

@export var weapon_owner:player
@export var Damage:float = 5.0
@export var kb:float=30.0
@export var swingDuration:float=0.75
var attack_area:Area3D:
	get():
		for i in get_children():
			if i is Area3D:
				return i
		return null
var currently_touching:
	get():
		if $Area3D.monitoring:
			
			return $Area3D.get_overlapping_bodies()
		else:
			return null

var attack_multiplier=1.0
var Enemies_damaged=[]

func interactJustPressedLMB(my_player:player,col):
	weapon_owner = my_player
	if my_player.is_on_floor():
		#my_player.rpc("play","attack_h")
		my_player.play("attack_h",false,swingDuration)
	else:
		my_player.play("attack_v",false,swingDuration)
		#my_player.rpc("play","attack_v")
func reset():
	swing(false,1.0)
	clear()
	
func swing(is_swing_start:bool,multiplier:float):
	g.p("swring: "+str(is_swing_start),self)
	attack_multiplier= multiplier if (is_swing_start) else 1.0 
	$Area3D.monitoring=is_swing_start
	clear()
 

func _on_area_3d_body_entered(body):
	
	if not weapon_owner:
		return
	if body in Enemies_damaged:
		return
	if body is enemies  or body is player and body != weapon_owner:
		body.damage.rpc(Damage*attack_multiplier,kb,global_position)
		g.p("Damage dealt by "+weapon_owner.Player_name+": "+str(Damage),self,g.DEBUG_MESSAGES_TYPE.COMBAT)
		add_body(body)
	else:
		if body is items:
			return
		else:
			return
		

func clear():
	Enemies_damaged=[]

func add_body(body):
	Enemies_damaged.append(body)
