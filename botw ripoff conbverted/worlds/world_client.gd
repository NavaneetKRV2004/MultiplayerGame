extends world


@export_group("UI nodes")

@export var label_server_name:Node
@export var label_ping:Node
@export var label_players_count:Node
@export var iptextbox:Node
@export var check:Node

func ping_server():
	var join_ip=iptextbox.text
	check.disabled=true
	selected_IP=join_ip
	
	
	
	if join_ip.to_lower()=="nav":
		join_ip="169.254.67.255"
	elif join_ip.to_lower()=="":
		join_ip="127.0.0.1"
	
	if not join_ip.is_valid_ip_address(): return
	multi.close()
	multi.create_client(join_ip,9999)
	multiplayer.multiplayer_peer=multi
	print("requesting server info")
	
@rpc
func ping_reply(d:Dictionary):#ping_name,ping_playercount,type,sunrot,pvp_enabled):
	
	label_server_name.text="[color=GREEN][b]"+d.ping_name.to_upper()+"[/b][/color]"
	label_players_count.text="[color=GREEN][b]"+str(d.ping_playercount)+"[/b][/color]"
	
	check.disabled=false

	$sun.rotation_degrees.x=d.sunrot
	pvp=d.pvp_enabled
	print("server info received: ",d)
	
	

func join_world():
	print("world loaded ",str(world_type))
	var world_types=global.world_types
	if world_type in world_types.keys():
		var b=load(world_types[world_type]).instantiate()
		add_child(b)
		
	id=multi.get_unique_id()
	spawn_player(id)
	$Control.hide()
	
	my_player=get_node(str(id))
	print("sending customization info")
	var player_details:Dictionary={
		"id":id,
		"name":my_player.Player_name,
		"hair":my_player.hair,
		"skin":my_player.skin,
		"pants":my_player.pants,
		"face":my_player.face,
		"shirt":my_player.shirt}
	rpc_id(1,"update_player_customization",player_details)
	multi.peer_disconnected.connect(delete_player)
	
	
	
@rpc("any_peer")
func update_player_customization(d:Dictionary):
	pass
