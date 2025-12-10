extends Node3D

@onready var camera:entity_camera=$head/Camera3D
@onready var ray = $head/ray
@onready var DebugData:Node=$"../DebugDetails"
@onready var player_world:Node=get_parent()

var velocity=Vector3.ZERO
var vxy=Vector2.ZERO
var speed=1
var boost=1


#controls
var js=5
var ms=100



	
func _ready() -> void:
	$head/Camera3D.perspective=1
func _process(_delta):
	if Input.is_action_just_released("lmb"):
		var col=ray.get_collider()
	if Input.is_action_just_pressed("server camera toggle"):
		if camera.current:
			camera.clear_current(false)
		else:
			camera.current = true
		

	if Input.is_action_pressed("boost"):
		boost=2
	else:
		boost=1

		velocity.y = boost*speed*(-int(Input.is_action_pressed("shift"))+int(Input.is_action_pressed("space")))

	var Tvelocity=Vector3()
	Tvelocity.x=0
	Tvelocity.z=0
	
	if Input.is_action_pressed("w"):
		Tvelocity.x+=cos(deg_to_rad(-get_rotation_degrees().y))
		Tvelocity.z+=sin(deg_to_rad(-get_rotation_degrees().y))
	if Input.is_action_pressed("a"):
		Tvelocity.x+=cos(deg_to_rad(-get_rotation_degrees().y-90))
		Tvelocity.z+=sin(deg_to_rad(-get_rotation_degrees().y-90))
	if Input.is_action_pressed("s"):
		
		Tvelocity.x+=-cos(deg_to_rad(-get_rotation_degrees().y))
		Tvelocity.z+=-sin(deg_to_rad(-get_rotation_degrees().y))
	if Input.is_action_pressed("d"):
		Tvelocity.x+=cos(deg_to_rad(-get_rotation_degrees().y+90))
		Tvelocity.z+=sin(deg_to_rad(-get_rotation_degrees().y+90))
		
		
		
	vxy=lerp(vxy,Vector2(Tvelocity.x,Tvelocity.z).normalized()*speed*boost,0.1)

	
	
	velocity=Vector3(vxy.x,velocity.y, vxy.y)
	

	
	position=position+velocity
	
	if $head.rotation_degrees.x >0:
		$head.rotation_degrees.x=0
	
	update_debug()

func _input(event):
	if Input.is_action_just_pressed("perspective"):
		if camera.perspective==1:
			camera.perspective=2
		else:
			camera.perspective=1
	
	
	if event is InputEventMouseMotion and Input.get_mouse_mode()==2:
		rotate_y(-event.get_relative().x*ms/22500.0)
		$head.rotate_z(-event.get_relative().y*ms/22500.0)




func update_debug():
	if DebugData.visible:
		var d=player_world.item_spawner.sync_items
		var d1={}
		for i in d:
			if d[i] in d1:
				d1[d[i]]+=1
			else:
				d1[d[i]]=1
		

		var debug=[
			"FPS: %d/%d %fms"%[Engine.get_frames_per_second(),Engine.get_physics_ticks_per_second(),RenderingServer.viewport_get_measured_render_time_gpu(get_viewport().get_viewport_rid())],
			"RAM: %d MB"%[OS.get_static_memory_usage()/1000000,],
			"Coordinates: (%d,%d,%d)"%[position.x,position.y,position.z],
			"Velocity: (%d,%d,%d)"%[velocity.x,velocity.y,velocity.z],
			"Velocity Magnitude: %2f"%velocity.length(),
		
			"Time: "+get_parent().strtime,
			"Rendering Radius: %s"%get_parent().ren,
			"FOV: %d"%(camera.fov+1), 
			"Perspective: %d"%camera.perspective,
			"Items on world: "+str(d1)
		]

		DebugData.text="\n".join(debug)
