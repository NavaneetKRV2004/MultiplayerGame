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
	my_player.Player_name=player_name.text if player_name.text !="" else "GNF soldier "+str(id)
	
	multi.peer_disconnected.connect(delete_player)

var PING:int=-80085

func ping():
	var time_msec:int=Time.get_ticks_msec()
	if my_player:
		rpc_id(1,"ping_reply",time_msec)
@rpc("any_peer")
func pong(time_msec:int):
	PING=Time.get_ticks_msec()-time_msec

@rpc("any_peer")
func ping_reply(time_msec:int):
	pass
