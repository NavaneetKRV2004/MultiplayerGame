extends CharacterBody3D
class_name living_entities
@export var mesh=''
@export var healthbar:NodePath
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var MAX_HEALTH:float
@export var HEALTH=50 
var vel=Vector3.ZERO


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity =10

@rpc("call_local")
func damage(dmg_pnts):
	
	HEALTH-=dmg_pnts
	get_node(healthbar).update(100.0*HEALTH/MAX_HEALTH)
	if get_node_or_null("blood") != null:
		$blood.emitting=true
	if HEALTH<=0:
		HEALTH=0
		death.rpc()
		

func death():
	return
	

func fall(d):
	# Add the gravity.
	
	if not is_on_floor():
		vel.y -= gravity * d
