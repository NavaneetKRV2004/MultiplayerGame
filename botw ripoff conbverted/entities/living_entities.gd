extends RigidBody3D
class_name living_entities
@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5

@export var maxHealth:float=50.0
@export var health:float=50 

var vel=Vector3.ZERO
var knockback_force:=Vector3.ZERO
@export var mesh=''

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity =10

@rpc("any_peer","call_local")
func damage(n:float=0.0,   kb:float=0.0,   global_source_position:Vector3=Vector3(0,0,0)    ):
	if is_multiplayer_authority():
		health-=n
		apply_impulse((position-global_source_position).normalized()*kb)
	else:
		$blood.emitting=true


func death():
	return
	
