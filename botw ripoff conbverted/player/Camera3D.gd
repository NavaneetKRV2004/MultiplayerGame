extends Camera3D
class_name entity_camera
var perspective:int=0
var default_perspective:int=0
@export var CUSTOM_FOV=75.0
@export var LOOK_CLOSE_FOV=20.0


func default():
	perspective=default_perspective
	size=1
func _process(delta):
	
	if perspective==0:
		fov=lerp(fov,CUSTOM_FOV,0.1)
		
		position=position.lerp(Vector3(0,-20.21,4.646),0.01)
		rotation_degrees.x=lerp_angle(rotation_degrees.x,71.6,0.01)
#		camera.position=Vector3(0,-20.21,4.646)
#		camera.rotation_degrees=Vector3(71.6,0,0)
	elif perspective==1:
		
		fov=lerp(fov,CUSTOM_FOV,0.1)
		position=position.lerp(Vector3.ZERO,0.1)
		rotation_degrees.x=lerp_angle(rotation_degrees.x,90,0.05)
	elif perspective ==2:
		
		fov=lerp(fov,LOOK_CLOSE_FOV,0.1)
		position=position.lerp(Vector3.ZERO,0.1)
		rotation_degrees.x=lerp_angle(rotation_degrees.x,90,0.05)
		if fov <LOOK_CLOSE_FOV+1:
			perspective=3
			
	elif perspective==3:
		if Input.is_action_just_pressed("scroll up"):
			fov=clamp(fov-1,1,150)
		if Input.is_action_just_pressed("scroll down"):
			fov=clamp(fov+1,1,150)
		position=position.lerp(Vector3.ZERO,0.1)
		rotation_degrees.x=lerp_angle(rotation_degrees.x,90,0.05)
		
	else:
		perspective=default_perspective
