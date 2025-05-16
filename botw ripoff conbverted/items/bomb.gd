extends RigidBody3D
@onready var material = $Sphere.material_overlay
var explosion_time=2.0
var time=0.0
var explforce=100.0

func _ready():
	pass 
	
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
	time+=delta
	if time>explosion_time:
		_die()
	
	material.set_shader_parameter("freq", pow(time/explosion_time,2)*5)
	#print(pow(time/explosion_time,2))
	
	
	
	
	
