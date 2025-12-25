extends items
@export var lit:bool = false
@onready var material:ShaderMaterial = $Sphere.material_overlay
@onready var particles= $GPUParticles3D
@export var explosion_time:float=2.0
@export var time:float=0.0
@export var explforce=100.0


func _die():
	if $Area3D.has_overlapping_bodies:
		for i in $Area3D.get_overlapping_bodies():
			if i.has_method("damage"):
				i.damage.rpc(50,50,global_position)
				
			if i is RigidBody3D:
				i.apply_impulse((i.position-position).normalized()*explforce)
	$CollisionShape3D.disabled=true
	if get_parent() is World:
		get_parent().item_spawner.spawn_particles("bomb",position+Vector3(0,5,0))
	super._die()
		
func reset():
	time=0.0
	lit=0
func debug():
	return ["lit: %s"%[lit], "Time: %d"%[time],"Time to explode: %d"%[explosion_time]]
func _physics_process(delta):
	super._physics_process(delta)
	_setHeld()
	
	particles.emitting=lit
		
	if lit:
		time+=delta
		if is_multiplayer_authority():
			if time>explosion_time :
				_die()
		var progress=time/explosion_time
		if 0.666<progress :
			material.set_shader_parameter("progress", 0.888) 
		elif 0.333<progress:
			material.set_shader_parameter("progress", 0.555) 
		elif 0.0<progress:
			material.set_shader_parameter("progress", 0.222) 
	else:
		material.set_shader_parameter("progress",0.0)
		
	#g.p(pow(time/explosion_time,2))
	
	
	
func interactJustPressedLMB(my_player,b):
	lit=true
func interactJustPressedRMB(my_player:player,b):
	var bomb=load("res://items/bomb.tscn").instantiate()
	add_child(bomb)
	bomb.name="bomb_%d"%randi()
	bomb.global_position=my_player.arrow_point.global_position
	bomb.global_rotation=my_player.arrow_point.global_rotation
	bomb.linear_velocity=my_player._get_facing_direction()*10
	my_player.player_world.item_spawner.make_copies(bomb,[lit,time])
	my_player.inventory.subtract_item(my_player.hotbar_index)
	queue_free()

func setExtraPropertiesForReplication(extra:Array):
	lit=extra[0]
	time=extra[1]
	
