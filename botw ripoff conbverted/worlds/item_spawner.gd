extends MultiplayerSpawner
class_name customMultiplayerSpawner
var sync_items={}
@export var world:World
func _ready() -> void:
	add_spawnable_scene("res://player/main character.tscn")
	for i in g.list_of_items:
		add_spawnable_scene(g.list_of_items[i]["scene"])



func make_copies(item:items,extra:Array=[]):
	_spawn_item.rpc_id(1,
		{ 
			
			"type":item.item_name,
			"pos":item.global_position,
			"rot":item.global_rotation,
			"vel":item.linear_velocity
		},extra)
	item.free()
	
@rpc("any_peer","call_remote")
func _spawn_item(d:Dictionary,extra:Array=[]):
	var it:items=load(g.list_of_items[d.type]["scene"]).instantiate()
	it.name=it.item_name+"_"+str(randi())
	world.add_child(it)
	it.global_position=d.pos
	it.global_rotation=d.rot
	it.linear_velocity=d.vel
	it.set_multiplayer_authority(1)
	if extra.size()!=0:
		it.setExtraPropertiesForReplication(extra)
	
	
	
func _process(delta: float) -> void:
	sync_items.clear()
	for i in world.get_children():
		if i is items:
			sync_items[i.name]=i.item_name
