extends world
@export var iplabel:NodePath

var debug=[]

	
func load_world_for_client(peer_id):
	rpc_id(peer_id,"ping_reply",world_type,$sun.rotation_degrees.x,pvp)
	print("\n\nsent world info\n\n")


func _on_host_button_down():
	$Control.hide()
	multi.create_server(9999)
	multiplayer.multiplayer_peer=multi
	
	
	#multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_connected.connect(send_world_details)
	multiplayer.peer_disconnected.connect(delete_player)
	id=multi.get_unique_id()
	
	
	
	
	
	world_name=get_node("Control/Control/Panel/MarginContainer/VBoxContainer/HBoxContainer/TextEdit2").text
	pvp=get_node("Control/Control/Panel/MarginContainer/VBoxContainer/HBoxContainer3/CheckButton").button_pressed
	var gm=get_node("Control/Control/Panel/MarginContainer/VBoxContainer/HBoxContainer4/gamemode")
	default_gamemode=gm.get_item_id(gm.selected)
	gm=get_node("Control/Control/Panel/MarginContainer/VBoxContainer/HBoxContainer6/landtype")
	world_type=gm.get_item_id(gm.selected)
	
	if world_type in global.world_types:
		var l=load(global.world_types[world_type]).instantiate()
		add_child(l)
	else:
		print("World type doesnt exist")
	

func send_world_details(peer_id):  #server
	
	var world_details:Dictionary = {
		"ping_name":world_name,
		"ping_playercount":players.size(),
		"type":world_type,
		"sunrot":$sun.rotation_degrees.x,
		"pvp_enabled":pvp
		}
		
	print("player requesting info")
	rpc_id(peer_id,"ping_reply",world_details)
	
	print("sent world info: ",world_details)
	
@rpc
func ping_reply(d:Dictionary):
	pass
	

	


func _on_label_ready():
	var jip=IP.get_local_addresses()
	var jip2=[]
	for i in jip:
		if ":" not in i:
			jip2.append(i)
			
	get_node(iplabel).text=str(jip2) #"Local address: "+jip[7]+"\nPublic Address: "+jip[3]

@rpc("any_peer")
func update_player_customization(d:Dictionary):
	spawn_player(d.id)
	print("Got Customizaion info of",d.id)
	var temp=players[d.id]
	temp.Player_name=d.name
	temp.hair=d.hair
	temp.skin=d.skin
	temp.pants=d.pants
	temp.face=d.face
	temp.shirt=d.shirt
	temp.update_looks()
	$chat.add_text(d.name+" joined")
