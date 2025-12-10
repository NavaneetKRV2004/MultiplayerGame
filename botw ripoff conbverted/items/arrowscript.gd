extends items
class_name Arrow

@export var Damage = 15.0
var arro_owner:String=""



func _physics_process(_delta):
	
	
	if linear_velocity.length()>20 and not held:
		
		$GPUParticles3D.emitting=true
	else:
		$GPUParticles3D.emitting=false
	
	for i in get_colliding_bodies():
		if i is shield:
			$bruh.reparent(i,true)
			queue_free()
			return
	
		elif i is StaticBody3D:
			freeze=true
			return

		elif i is enemies or (i is player and i.name != arro_owner):
			if is_multiplayer_authority():
				g.p(i.name+" was shot by"+arro_owner+ " and did damage:"+str(Damage*linear_velocity.length()/10.0),self,g.DEBUG_MESSAGES_TYPE.COMBAT)
				i.damage.rpc(floor(Damage*linear_velocity.length()/10.0),100,global_position)
			$bruh.reparent(i,true)
			queue_free()
			return
			
