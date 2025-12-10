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
		
	
	var l=load(g.world_types[world_type][1]).instantiate()
	add_child(l)
	
	
	




func _on_label_ready():
	var jip=IP.get_local_addresses()
	for i in jip:
		if i.begins_with("192."):
			%iptext.text="Local Address: "+i
			break



	
func timer_spawn_trident():
	var t =load("res://items/trident.tscn")
	var temp
	for i in range(9):
		temp=t.instantiate()
		temp.name=StringName("penis"+str(randi()))
		temp.position=Vector3(i/3*10,100,(i%3)*10)
		add_child(temp)
