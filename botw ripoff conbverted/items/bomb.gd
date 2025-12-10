extends items
@export var lit:bool = false
@onready var material = $Sphere.material_overlay
@export var explosion_time=2.0
@export var time=0.0
@export var explforce=100.0


func _die():
	if $Area3D.has_overlapping_bodies:
		for i in $Area3D.get_overlapping_bodies():
			if i.has_method("damage"):
				i.damage(10)
				if "kb" in i:
					i.kb.dir=(i.position-position).normalized()
					i.kb.mag=explforce
				
			if i is RigidBody3D:
				i.apply_impulse((i.position-position).normalized()*explforce)
	$CollisionShape3D.disabled=true
	queue_free()
		


func _physics_process(delta):
	_setHeld()
	
	if not held and lit:
		time+=delta
		if time>explosion_time:
			_die()
		
		material.set_shader_parameter("freq", pow(time/explosion_time,2)*5)
	#g.p(pow(time/explosion_time,2))
	
	
	

func interactJustPressedRMB(a,b):
	position=position+Vector3(0,3,0)
	linear_velocity=Vector3(10*cos(deg_to_rad(-get_rotation_degrees().y)),2,10*sin(deg_to_rad(-get_rotation_degrees().y)))

	
