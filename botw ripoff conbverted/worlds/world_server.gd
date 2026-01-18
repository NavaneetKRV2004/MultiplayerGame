extends World
class_name WorldServer

func _ready() -> void:
	super._ready()

	
	for i in range(len(g.world_types)):
		%landtype.add_item(g.world_types[i][0],i)
	if "server" in s.arguments:
		#var args=JSON.parse_string(s.arguments["server"])
		#if not args is  Dictionary:
			#args={}
		#world_name=args["name"] if "name" in args else "Server World"
		#world_type=args["type"] if "type" in args else 0
		#pvp=args["pvp"] if "pvp" in args else true
		#default_gamemode=args["gm"] if "gm" in args else 0
		#print("Server starting")
		
		_on_host_button_down()

func _on_host_button_down():
	$Control.hide()
	multi=ENetMultiplayerPeer.new()
	multi.create_server(g.PORT_GAME)
	multiplayer.multiplayer_peer=multi
	
	
	#multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(delete_player)
	id=multi.get_unique_id()
	
	
	
	
	if not "server" in s.arguments:
		world_name=%TextEdit2.text if %TextEdit2.text !="" else "World"
		pvp=%CheckButton.button_pressed
		default_gamemode=%gm.get_selected_id()
		world_type=%landtype.get_selected_id()
		ischeatsEnabled=%cheats.button_pressed
		
	
	var l=load(g.world_types[world_type][1]).instantiate()
	add_child(l)
	
	
	




func _on_label_ready():
	var jip=IP.get_local_addresses()
	for i in jip:
		if i.begins_with("192."):
			%iptext.text="Local Address: "+i
			break
			
			
func save_world():
	var save=FileAccess.open("FirstWorldEver.world",FileAccess.WRITE)
	var buffer:String=""
	for i in get_children():
		if i is items:
			var temp=i.item_name+":\n\tpos: "+str(i.position.x)+" "+str(i.position.y)+" "+str(i.position.z)
			temp+="\n\trot: "+str(i.rotation.x)+" "+str(i.rotation.y)+" "+str(i.rotation.z)
			buffer+="\n"+temp
	save.store_string(buffer)
	

			
