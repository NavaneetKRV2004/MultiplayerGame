extends World 
class_name WorldClient




@onready var options=$Control2
@export_group("player")
@export var player_name:TextEdit
@export var skin:ColorPickerButton

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("gamemode_survival"):
		var p=load("res://particles/bomb_particles.tscn").instantiate()
		add_child(p)
		p.restart()
		p.position.y=150
		p.emitting=true
		
	
	
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
	
	
