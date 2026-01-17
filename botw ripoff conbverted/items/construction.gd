class_name Construction extends items

@export var held_size_ratio:float=0.2
enum constr{
	FLOOR_CEILING,
	WALL,
	TREE
}
@export var construction_type:constr=constr.WALL
var ghost:MeshInstance3D=null
var ghostOn:bool=false

func _ready() -> void:
	super._ready()
	if not ghost:
		for i in get_children():
			if i is MeshInstance3D:
				ghost=i.duplicate()
				
				
				break
	ghost.scale=Vector3.ONE
func _setHeld():
	
	var value= not get_parent() is World
	freeze=true
	held=value
	col.disabled=value
	
	if held:
		for i in get_children():
			if i is MeshInstance3D:
				i.scale=Vector3(held_size_ratio,held_size_ratio,held_size_ratio)
	else:
		for i in get_children():
			if i is MeshInstance3D:
				i.scale=Vector3(1,1,1)
	
	
func interactJustPressedLMB(player_ref:player, item_looked_at):
	ghostOn=true
	if not is_ancestor_of(ghost):
		ghost.hide()
		add_child(ghost)
		ghost.scale=Vector3.ONE
		ghost.global_position=player_ref.ray.global_position+ player_ref.ray.target_position
		ghost.show()
		idle(player_ref)
		
	
func interactJustPressedRMB(player_ref:player, item_looked_at):
	if not ghost.visible:
		return
	player_ref.player_world.item_spawner.create_item(item_name,ghost.global_position,ghost.global_rotation,Vector3.ZERO)
	player_ref.inventory.subtract_item(player_ref.hotbar_index)

func interactReleasedLMB(player_ref:player, item_looked_at):
	ghostOn=false
	if is_ancestor_of(ghost):
		remove_child(ghost)
func interactReleasedRMB(player_ref:player, item_looked_at):
	pass
func idle(player_ref):
	if ghost and held and ghostOn:
		if player_ref.ray.is_colliding():
			ghost.global_position=player_ref.ray.get_collision_point()
			ghost.show()
		else:
			ghost.hide()
		match construction_type:
			constr.FLOOR_CEILING:
				ghost.global_position.y+=0.2
			constr.WALL:
				ghost.global_position.y+=2.0
			constr.TREE:
				pass
			
		
