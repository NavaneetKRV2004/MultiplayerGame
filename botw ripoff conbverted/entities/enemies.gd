extends living_entities
class_name enemies

var target:player
var world:World
var vision_distance=10.0
var states=["roam",'approach','attack']

func _ready():
	world=get_parent()
	
@rpc("call_local")
func death():
	g.p("died",self,g.DEBUG_MESSAGES_TYPE.COMBAT)
	queue_free()
	
func find_target():
	target=null
	
	var min_dist
	if world.players.size()>0:
		var players=world.players.values()
		players.sort_custom(func (a,b): return position.distance_squared_to(a.position)<position.distance_squared_to(b.position))
		if position.distance_squared_to(players[0].position)<pow(vision_distance,2):
			target=players[0]
func melee():
	pass
func _physics_process(delta):
	if position.y<-100 or health<0:
		death()
	if not is_multiplayer_authority(): return
	
	find_target()
	if target:
		$MeshInstance3D2/AnimatedSprite3D.frame=1
		look_at(target.position,Vector3(0,1,0))
		rotation_degrees.x=0
		rotation_degrees.z=0
	else:
		$MeshInstance3D2/AnimatedSprite3D.frame=0
#		rotation_degrees.y=(target.position-position)
	
	if target:
		if position.distance_to(target.position)>=4.0:
			var dir=(target.position-position).normalized()*SPEED
			vel.x=dir.x
			vel.z=dir.z
		else:
			vel.x=0.0
			vel.z=0.0
			melee()
	else:
		vel.x=0.0
		vel.z=0.0
		
	apply_central_force(vel)
	
	
	
