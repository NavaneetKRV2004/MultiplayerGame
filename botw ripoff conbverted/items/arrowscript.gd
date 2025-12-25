extends items
class_name Arrow

@export var Damage = 15.0
var arrow_owner:String=""


#0: arrow owner
func setExtraPropertiesForReplication(extra:Array):
	arrow_owner=extra[0]

func _physics_process(_delta):
	var parent = get_parent()
	
	
	if held or not parent is World :
		global_transform=get_parent().global_transform

	if not parent is World:
		return
		
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

		elif i is enemies or (i is player and i.Player_name != arrow_owner):
			if is_multiplayer_authority():
				g.p(i.name+" was shot by"+arrow_owner+ " and did damage:"+str(Damage*linear_velocity.length()/10.0),self,g.DEBUG_MESSAGES_TYPE.COMBAT)
				i.damage.rpc(floor(Damage*linear_velocity.length()/10.0),100,global_position)
			$bruh.reparent(i,true)
			queue_free()
			return
			
