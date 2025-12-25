extends RigidBody3D
class_name items
var ticks_spent:float=0

@export_group("Item Details")
@export var item_name:String
@export var col:Node
var held:bool=false
@export var replication_interval:float=0.5
@export var collectable:bool=true
@export var despawnable:bool=false
@export var despawntime:float=10000
@export var destroyable:bool
@export var stackable:bool=false
@export var inventory_texture:Texture2D=null

@export_group("Actions")
@export var LMB:String=""
@export var RMB:String=""
@export var wheelUp:String=""
@export var wheelDown:String=""

func _setHeld():
	var value:bool = not get_parent() is World	
	for i in get_children():
		if i is MultiplayerSynchronizer:
			if value:
				i.process_mode=Node.PROCESS_MODE_DISABLED
			else:
				i.process_mode=Node.PROCESS_MODE_INHERIT
	freeze=value
	
	held=value
	col.disabled=value
		
func _die():
	if is_multiplayer_authority():
		delete_copies()
	g.p(item_name+" despawned",self,g.DEBUG_MESSAGES_TYPE.SPAWN)
	#g.p("collision: "+str(not col.disabled),self)
	queue_free()
	
func _ready():
	#set_multiplayer_authority(1)
	
	tree_entered.connect(_setHeld)
	_setHeld()
	
	if not inventory_texture:
		push_error("%s has no inventory texture"%item_name)
	
	
	freeze_mode=RigidBody3D.FREEZE_MODE_KINEMATIC
	
	



func _physics_process(delta: float) -> void:
	
		
	#if despawnable and not held:
		#if (ticks_spent>despawntime):
			#_die()
		#else:
			#ticks_spent+=delta
	#else:
		#ticks_spent=0
	##if global_position.y<-500:
		##_die()
	if held:
		global_transform=get_parent().global_transform

func interactJustPressedLMB(player_ref:player, item_looked_at):
	pass
func interactJustPressedRMB(player_ref:player, item_looked_at):
	pass

func interactReleasedLMB(player_ref:player, item_looked_at):
	pass
func interactReleasedRMB(player_ref:player, item_looked_at):
	pass
func reset():
	pass
func debug()->Array:
	return []
func delete_copies():
	rpc("delete_copies_rpc")
	
	
@rpc("any_peer","call_remote")
func delete_copies_rpc():
	queue_free()
	
func setExtraPropertiesForReplication(extra:Array):
	pass
