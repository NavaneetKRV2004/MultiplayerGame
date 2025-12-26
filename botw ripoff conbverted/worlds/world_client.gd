extends World 
class_name WorldClient




@onready var options=$Control2
@export_group("player")
@export var player_name:TextEdit
@export var skin:ColorPickerButton


	
	
func join_world(ip:String,type:int):
	g.p("Joined ip: "+ip,self,g.DEBUG_MESSAGES_TYPE.LOGIN)
	multi=ENetMultiplayerPeer.new()
	multi.create_client(ip,g.PORT_GAME)
	multiplayer.multiplayer_peer=multi
	world_type=type
	
	var b=load(g.world_types[world_type][1]).instantiate()
	add_child(b)
	g.p("world loaded "+str(world_type),self,g.DEBUG_MESSAGES_TYPE.LOGIN)
		
	id=multi.get_unique_id()
	
	$Control.queue_free()
	
	my_player=spawn_player(id)
	my_player.skin=skin.color
	my_player.Player_name=player_name.text
	
	multi.peer_disconnected.connect(delete_player)
	
	
