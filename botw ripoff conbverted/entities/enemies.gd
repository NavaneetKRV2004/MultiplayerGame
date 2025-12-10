extends living_entities
class_name enemies

var target
var world
var is_on_host:bool
var vision_distance=10.0
var states=["roam",'approach','attack']
var kb={"dir":Vector3.ZERO,"mag":0}
func _ready():
	
	world=get_parent()
	
	set_multiplayer_authority(1)
		
@rpc("call_local")
func death():
	g.p("died",self,g.DEBUG_MESSAGES_TYPE.COMBAT)
	queue_free()
	
func find_target():
	target=null
	var players=world.players
	for i in players:
		if "position" in players[i]:
			if position.distance_to(players[i].position) <vision_distance:
				target=players[i]
			
func melee():
	pass
func _physics_process(delta):
	if position.y<-100:
		death()
	if not is_multiplayer_authority(): return
	
	find_target()
	if target==null:
		$MeshInstance3D2/AnimatedSprite3D.frame=0
	else:
		$MeshInstance3D2/AnimatedSprite3D.frame=1
#		rotation_degrees.y=(target.position-position)
		look_at(target.position,Vector3(0,1,0))
		rotation_degrees.x=0
		rotation_degrees.z=0
	fall(delta)
	if target != null:
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
		
	kb.mag-=0.4
	kb.mag=clampf(kb.mag,0.0,100.0)
	velocity=vel+kb.dir*kb.mag
	

	
	move_and_slide()
	
	
	
