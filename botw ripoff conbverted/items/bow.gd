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
@export var my_player:player
@export var anim:AnimationPlayer
@export var point:Marker3D
var arrow:Arrow

func withdraw():
	anim.play("withdraw",-1,1/withdraw_time)
	
func release():
	
	if arrow:
		arrow.name="arrow%d"%randi()
		arrow.global_position=my_player.arrow_point.global_position
		arrow.global_rotation=my_player.arrow_point.global_rotation
		arrow.linear_velocity=my_player._get_facing_direction()*arrow_speed*anim.current_animation_position
		my_player.player_world.item_spawner.make_copies(arrow)
		
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
	arr.arro_owner=my_player.name
	
	arrow=arr
	


func interactJustPressedRMB(my_player,b):
	self.my_player=my_player
	
	if not isLoaded():
		var arr_index=my_player.inventory.getFirstArrowIndexInInventory()
		var arrow_temp=null
		
		if arr_index !=-1:
			arrow_temp=my_player.inventory.subtract_item(arr_index)
			loadArrow(arrow_temp)
	withdraw()
	
	
	my_player.speed/=2.0

		
	
func interactReleasedRMB(my_player,b):
		release()
		my_player.speed*=2
