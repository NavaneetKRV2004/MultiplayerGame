extends MultiplayerSpawner
class_name customMultiplayerSpawner

var ps=preload("res://particles/bomb_particles.tscn")
var sync_items={}
@export var world:World
func _ready() -> void:
	add_spawnable_scene("res://player/main character.tscn")
	for i in g.list_of_items:
		add_spawnable_scene(g.list_of_items[i]["scene"])



func make_copies(item:items,extra:Array=[]):
	var temp:Array=[]
	temp.append(item.item_name)
	temp.append(item.global_position)
	temp.append(item.global_rotation)
	temp.append(item.linear_velocity)
	item.free()
	_spawn_item.rpc_id(1,
		{ 
			
			"type":temp[0],
			"pos":temp[1],
			"rot":temp[2],
			"vel":temp[3]
		},extra)
	
@rpc("any_peer","call_remote")
func _spawn_item(d:Dictionary,extra:Array=[]):
	var it:items=load(g.list_of_items[d.type]["scene"]).instantiate()
	it.name=it.item_name+"_"+str(randi())
	it.position=d.pos-world.position
	it.rotation=d.rot
	it.linear_velocity=d.vel
	it.set_multiplayer_authority(1)
	if extra.size()!=0:
		it.setExtraPropertiesForReplication(extra)
	world.add_child(it)

var particles_queue=[]
func spawn_particles(type:String,global_position:Vector3):
	_rpc_spawn_particles.rpc(type,global_position)
@rpc("any_peer","call_local")
func _rpc_spawn_particles(type:String,global_position:Vector3):
	particles_queue.append([type,global_position])
	
	

	
func _process(delta: float) -> void:
	
	if particles_queue!=[]:
		var pl=particles_queue.pop_back()
		var p=load(g.particles[pl[0]]).instantiate()
		get_parent().add_child(p)
		p.position=pl[1]
		p.emitting=true
	
	sync_items.clear()
	for i in world.get_children():
		if i is items:
			sync_items[i.name]=i.item_name
		if i is GPUParticles3D and not i.emitting:
			i.queue_free() 
