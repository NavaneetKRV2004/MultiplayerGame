extends Node3D

@onready var camera:entity_camera=$head/Camera3D
@onready var ray = $head/ray
@onready var DebugData:Node=$"../DebugDetails"

var velocity=Vector3.ZERO
var vxy=Vector2.ZERO
var speed=1
var boost=1


#controls
var js=5
var ms=100



	
	
func _process(delta):
	if Input.is_action_just_released("lmb"):
		var col=ray.get_collider()
		

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
		camera.perspective+=1
	
	
	if event is InputEventMouseMotion and Input.get_mouse_mode()==2:
		rotate_y(-event.get_relative().x*ms/22500.0)
		$head.rotate_z(-event.get_relative().y*ms/22500.0)




func update_debug():
	if DebugData.visible:


		var debug=["FPS: "+str(floor(Engine.get_frames_per_second()))+" / "+str(floor(Engine.get_physics_ticks_per_second())),
		"Coordinates: (" + str(floor(position.x)) + ",     " + str(floor(position.y)) + ",      "+str(floor(position.z))+")",
		"Velocity: ("+str(floor(velocity.x)) + "   ," + str(floor(velocity.y)) + "   ," + str(floor(velocity.z)) + "     )",
		"Velocity Magnitude: "+str(round(velocity.length()*100.0)/100.0),
		
		"Time: "+get_parent().strtime,
		"Rendering Radius: "+str(get_parent().ren),
		"FOV: "+str(ceil(camera.fov)), 
		"Perspective: "+str(camera.perspective),
		]

		DebugData.text="\n".join(debug)
