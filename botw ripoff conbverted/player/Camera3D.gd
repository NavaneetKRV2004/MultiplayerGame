
extends Camera3D
class_name entity_camera
@export var perspective:int=0
var default_perspective:int=1
@export var CUSTOM_FOV=75.0
@export var LOOK_CLOSE_FOV=20.0

@export var isWobbling:bool = false
@export var wobbling_rate:float=5.0
@export var isRunning:bool=false

var wobble_angle_cumulative:float=0.0

func default():
	perspective=default_perspective
	size=1
func _process(_delta):
	if s:
		
		CUSTOM_FOV=float(s.settings.FOV)
	if perspective==0:     #third person
		fov=lerp(fov,CUSTOM_FOV,0.1)
		
		position=position.lerp(Vector3(0,-5.847,1.743),0.01) 
		rotation_degrees.x=lerp_angle(rotation_degrees.x,71.6,0.01)
#		camera.position=Vector3(0,-20.21,4.646)
#		camera.rotation_degrees=Vector3(71.6,0,0)
	elif perspective==1:   #First person
		
		fov=lerp(fov,CUSTOM_FOV,0.1)
		position=position.lerp(Vector3.ZERO,0.1)
		rotation_degrees.x=lerp_angle(rotation_degrees.x,90,0.05)
	elif perspective ==2:
		
		fov=lerp(fov,LOOK_CLOSE_FOV,0.1)
		position=position.lerp(Vector3.ZERO,0.1)
		rotation_degrees.x=lerp_angle(rotation_degrees.x,90,0.05)
		if fov <LOOK_CLOSE_FOV+1:
			perspective=-1
			
	elif perspective==-1:
		if Input.is_action_just_pressed("scroll up"):
			fov=clamp(fov-1,1,150)
		if Input.is_action_just_pressed("scroll down"):
			fov=clamp(fov+1,1,150)
		position=position.lerp(Vector3.ZERO,0.1)
		rotation_degrees.x=lerp_angle(rotation_degrees.x,90,0.05)
		
	else:
		default()
	
	_damage_shake(_delta)
	_wobble(_delta)
		
		
		
		
@export_group("shake")
@export var shake_intensity:float = 0.0
@export var shake_decay:float = 1.0  # How fast the shake fades out
@export var max_offset:float = 1.0  # Maximum offset in pixels
var offset:Vector2=Vector2.ZERO

func _damage_shake(delta):
	if shake_intensity > 0:
		h_offset = randf_range(-1, 1) * shake_intensity * max_offset
		v_offset = randf_range(-1, 1) * shake_intensity * max_offset
		

		shake_intensity = max(shake_intensity - delta * shake_decay, 0.0)
	else:
		h_offset=0
		v_offset=0
	

# Call this function to start the shake
func start_shake(intensity: float = 1.0, decay: float = 5.0):
	shake_intensity = intensity
	shake_decay = decay
	
func _wobble(delta):
	if not isWobbling:
		wobble_angle_cumulative=0.0
		return
	wobble_angle_cumulative+=delta*wobbling_rate*(2.0 if isRunning else 1.0)
	h_offset+=sin(wobble_angle_cumulative)/10.0
