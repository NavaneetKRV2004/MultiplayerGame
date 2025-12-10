class_name ItemSynchronizer extends Node

@export var base_world:Node
@export var isServer:bool
@export var enabled:bool=true

@export var prev_sync_items:Dictionary={}
@export var received_list:Dictionary={}

@export var sync_items:Dictionary={}
#func _ready() -> void:
	#multiplayer.peer_connected.connect(update_details_to_newly_joined_client)

func _process(_delta: float) -> void:
	if isServer:
		prev_sync_items=sync_items.duplicate(true)
		
	sync_items.clear()
	for i in base_world.get_children():
		if i is items:
			sync_items[i.name]=i.item_name
	if enabled:
		if isServer:
			if prev_sync_items != sync_items:
				rpc("update_clients",sync_items)
		else:
			for i in received_list.merged(sync_items):
				if i not in sync_items:
					spawn(i)
				elif i not in received_list:
					despawn(i)
@rpc("any_peer","call_remote","reliable")
func remove_item(node_name:StringName):
	var err=base_world.get_node(str(node_name))
	if err:
		err.queue_free()
		err=sync_items.erase(node_name)
	else:
		push_error("item requested to remove doesnt exist in server")
	
func request_item_removal(node_name:StringName):
	rpc_id(1,"remove_item",node_name)



@rpc("any_peer","call_remote","unreliable")
func update_clients(d:Dictionary):
	received_list=d
	
	
func spawn(i:StringName):
	var spawned=load(g.list_of_items[received_list[i]]["scene"]).instantiate()
	spawned.name=i
	spawned.position=Vector3(0,1000,0)
	base_world.add_child(spawned)
	
func despawn(i:StringName):
	get_parent().get_node(str(i)).queue_free()
	
#func update_details_to_newly_joined_client(_id):
	#for i in sync_items:
		#var err=base_world.get_node(str(i))
		#if not err:
			#err.update_properties(true)
		#else:
			#push_error("item not found to update details for new client")
			
			
#region Packets
enum packetType{
	DROPPED_ITEM_CS,
	PICKED_ITEM_CS
	
	
	
}

#endregion
