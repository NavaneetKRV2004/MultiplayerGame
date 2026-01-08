extends items
class_name Arrow

@export var Damage:float = 1.5
var arrow_owner:String=""
var velocity_before_last_collision:Vector3=Vector3.ONE

#0: arrow owner
func setExtraPropertiesForReplication(extra:Array):
	arrow_owner=extra[0]

func _physics_process(_delta):
	var parent = get_parent()
	
	
	if held or not parent is World :
		global_transform=get_parent().global_transform

	if not parent is World:
		return
	
	if is_multiplayer_authority() and linear_velocity.length() > 1 and  get_contact_count()==0:
		var current_dir = transform.basis.y.normalized()
		var target_dir = linear_velocity.normalized()
		# Axis to rotate around
		var axis = current_dir.cross(target_dir)
		# How far off we are (0 → aligned, 1 → opposite)
		var angle_error = axis.length()
		if angle_error < 0.001:
			return
		axis = axis.normalized()
		# Tune this value
		var torque_strength = 10.0
		apply_torque(axis * angle_error * torque_strength)
		



	if linear_velocity.length()>10 and not held:
		$GPUParticles3D.emitting=true
	else:
		$GPUParticles3D.emitting=false
	
	for i in get_colliding_bodies():
		if i is shield:
			$bruh.reparent(i,true)
			queue_free()
			return
	
		elif i is StaticBody3D :
			freeze=true
			return

		elif i is enemies or (i is player and i.Player_name != arrow_owner):
			if is_multiplayer_authority():
				g.p(i.name+" was shot by "+arrow_owner+ " and did damage:"+str(floor(Damage*velocity_before_last_collision.length())) +"moving at "+str(velocity_before_last_collision.length())+" m/s",self,g.DEBUG_MESSAGES_TYPE.COMBAT)
				i.damage.rpc(floor(Damage*velocity_before_last_collision.length()),10,global_position)
				delete_copies()
			
			return
			
	velocity_before_last_collision=linear_velocity
