extends RigidBody3D
class_name items
var ticks_spent=0


@export var item_name:String
@export var COLLECTABLE:bool=true
@export var despawnable:bool=false
@export var despawntime:int
@export var destroyable:bool

func _die():
	print("yo")
	return
	
func _ready():
	linear_damp=1
	gravity_scale=2
	


func _physics_process(delta):
	if position.y <=-50:
		position=Vector3(0,100,0)

func _checkdespawn(delta):
	
	if despawnable:
		
		if (ticks_spent==120*despawntime or ticks_spent>despawntime*120):
			_die()
		else:
			ticks_spent+=1
		if position.y<-50:
			_die()
