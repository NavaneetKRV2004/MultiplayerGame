extends items

@export var Damage = 15.0

var arro_owner:String=""

func _ready():
	
	gravity_scale = 1
	linear_damp=0
	
func _die():
	
	$CollisionShape3D.disabled=true
	queue_free()
	
func _physics_process(delta):
	_checkdespawn(3)
	if linear_velocity.abs().length()>5 and not freeze:
		$GPUParticles3D.emitting=true
	else:
		$GPUParticles3D.emitting=true
	var col = get_colliding_bodies()
	
	if col != []:
		for i in col:
			if i is shield:
				$bruh.reparent(i,true)
				queue_free()
				return
		
			elif i is StaticBody3D:
				freeze=true
				return

			elif i is enemies or (i is player and i.name != arro_owner):
				i.damage(Damage)
				if "kb" in i:
					i.kb.dir=(i.position-position).normalized()
					i.kb.mag=10
				$bruh.reparent(i,true)
				queue_free()
				return
				
