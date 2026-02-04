extends World
class_name WorldServer

@onready var server_camera:=$ServerSpectator
func _ready() -> void:
	super._ready()
	
	
	for i in range(len(g.world_types)):
		%landtype.add_item(g.world_types[i][0],i)
	if "server" in s.arguments:
		_on_host_button_down()

func _on_host_button_down():
	$Control.hide()
	multi=ENetMultiplayerPeer.new()
	multi.create_server(g.PORT_GAME)
	multiplayer.multiplayer_peer=multi
	
	
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(delete_player)
	id=multi.get_unique_id()
	
	
	
	
	if not "server" in s.arguments:
		world_name=%TextEdit2.text if %TextEdit2.text !="" else "World"
		pvp=%CheckButton.button_pressed
		default_gamemode=%gm.get_selected_id()
		world_type=%landtype.get_selected_id()
		ischeatsEnabled=%cheats.button_pressed
		sky=%sky.get_selected_id()
	else:
		world_name=s.arguments["name"] if "name" in s.arguments else "Debug Server"
		world_type=int(s.arguments["type"]) if "type" in s.arguments else 0
		pvp=not ("pvp" in s.arguments and (s.arguments["pvp"] in ["0","False","false","FALSE"])) 
		default_gamemode=int(s.arguments["gm"]) if "gm" in s.arguments else 0
		ischeatsEnabled=not ("cheats" in s.arguments and (s.arguments["pvp"] in ["0","False","false","FALSE"])) 
	
	var l=load(g.world_types[world_type][1]).instantiate()
	add_child(l)
	land=l
	
	




func _on_label_ready():
	var jip=IP.get_local_addresses()
	for i in jip:
		if i.begins_with("192."):
			%iptext.text="Local Address: "+i
			break
			
			
func save_world(save_as:String="new_world"):
	var save=FileAccess.open(save_as+".world",FileAccess.WRITE)
	var buffer:String=""
	for i in get_children():
		if i is items:
			var temp=i.item_name+":\n\tpos: "+str(i.position.x)+" "+str(i.position.y)+" "+str(i.position.z)
			temp+="\n\trot: "+str(i.rotation.x)+" "+str(i.rotation.y)+" "+str(i.rotation.z)
			buffer+="\n"+temp
	save.store_string(buffer)
	
@rpc("any_peer")
func ping_reply(time_msec:int):
	var x=multiplayer.get_remote_sender_id()
	if x>1:
		rpc_id(x,"pong",time_msec)
	
@rpc("any_peer")
func pong(time_msec:int):
	pass
