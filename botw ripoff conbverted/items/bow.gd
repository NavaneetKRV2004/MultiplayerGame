extends items
class_name Bow
##Speed of arrow after it is shot
@export var arrow_speed:float=30.0
##Time in seconds it takes the bow to withdraw
@export var withdraw_time:float=0.5
##percentage of withdraw time that must pass before arrow is allowed to be shot
const minimum_withdraw_percentage:float=0.1
##Time it takes for string to come back to rest
const release_animation_time:float=0.25
@export var bow_fov:float=70
@export var my_player:player=null
@export var anim:AnimationPlayer
@export var point:Marker3D
@export var string:Node3D
var arrow:Arrow

var progress:float=0:
	get():
		return string.progress
	

func withdraw():
	anim.play("withdraw",-1,1/withdraw_time)
	
func release():
	
	if arrow:
		arrow.name="arrow%d"%randi()
		arrow.global_position=my_player.arrow_point.global_position
		arrow.global_rotation=my_player.arrow_point.global_rotation
		arrow.linear_velocity=my_player._get_facing_direction()*arrow_speed*anim.current_animation_position
		my_player.player_world.item_spawner.make_copies(arrow,[my_player.Player_name])
		assert(my_player.Player_name != "")
		
	anim.play("withdraw",-1,-1/release_animation_time)
	arrow=null
	
func isLoaded()->bool:
	return point.get_child_count()>0
func loadArrow(arr:Arrow):
	if isLoaded():
		arrow.queue_free()
		push_error("Arrow deleted from bow while loading another arrow")
	if arr.get_parent():
		arr.reparent(point)
	else:
		point.add_child(arr)
	arr.position=Vector3.ZERO
	arr.rotation=Vector3.ZERO
	arr.arrow_owner=my_player.name
	
	arrow=arr
	


func interactJustPressedRMB(my_player:player,b):
	self.my_player=my_player
	
	if not isLoaded():
		var arr_index=my_player.inventory.getFirstArrowIndexInInventory()
		var arrow_temp=null
		
		if arr_index !=-1:
			arrow_temp=my_player.inventory.subtract_item(arr_index)
			loadArrow(arrow_temp)
	withdraw()
	
	
	

		
	
func interactReleasedRMB(my_player,b):
		release()
		
func debug():
	
	return ["Shooting speed: %d"%[arrow_speed],
	"Withdraw Time: %d"%[withdraw_time],
	"Progress: %f"%[progress],
	"Potential damage: %d" %[arrow_speed*1.5*(progress)]
	]
func idle(player_ref):
	if progress >0.0:
		player_ref.camera.perspective=3
		player_ref.camera.BOW_FOV=bow_fov
	else:
		player_ref.camera.default()
	global_transform=player_ref.bow_placement.global_transform
	
#func _physics_process(delta: float) -> void:
	#super._physics_process(delta)
	#if my_player:
		#global_transform=my_player.bow_placement.global_transform
func reset(player_ref):
	if arrow and player_ref:
		player_ref.inventory.add_item(arrow,1)
		arrow=null
	string.progress=0
	anim.play("RESET")
