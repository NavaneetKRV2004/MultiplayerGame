extends Node3D
class_name world

@export var player_scene:String ="res://player/main character.tscn"
var Player = load(player_scene)
 
@export_group("World Settings")
@export var world_name="Temporary world"
@export var world_type:int
@export var default_gamemode:int
@export var ren=20
@export var timeperiod = 200
@export var pvp:bool=true
@export var time=0.0
var strtime:String


var players={}
var my_player=0



var multi=ENetMultiplayerPeer.new()
var id
var selected_IP=""


@export var chat:Node

			
func add_player(path,id):
	players[id]=path
	
func spawn_player(peer_id:int):
	var mc=Player.instantiate()
	
	mc.name=str(peer_id)
	
	mc.position=Vector3(0,50,0)
	add_child(mc)
	
	add_player(mc,peer_id)
	chat.add_text(str(peer_id)+" joined")
	if peer_id==1: return
	
#func load_world_for_client(peer_id):
	#rpc_id(peer_id,"world_details",world_type)

func delete_player(peer_id:int):
	
	if peer_id==1:
		multi.close()
		get_tree().change_scene_to_file("res://world.tscn")
	chat.add_text(str(peer_id)+" disconnected")
	print("peer to delete is ",str(peer_id))
	var child=get_node_or_null(str(peer_id))
	if child!=null:
		child.queue_free()
	players.erase(peer_id)
	
			
func _ready():
	
	var fil=FileAccess.open("user://savedata.txt",FileAccess.READ)
	var cont=fil.get_as_text()
	
	var nj=JSON.parse_string(cont)
	Engine.max_fps=nj["fps"]
	
	#$Node3D.ms=nj["Mouse Sensitivity"]
	#$Node3D.js=nj["Joystick Sensitivity"]

	fil.close()
	

	
	
	
	

	
func _physics_process(delta):
	if Input.is_key_pressed(KEY_HOME):
		multi.close()
		get_tree().change_scene_to_file("res://Main logic/titlescreen.tscn")
	
	
	if timeperiod!=0:
		$sun.rotate_x(deg_to_rad(360.0/timeperiod * delta))
		$WorldEnvironment.environment.sky.sky_material.sky_top_color=lerp(Color(0.325490, 0.564705, 0.980392),Color(0,0,0),(1+sin($sun.rotation.x-PI/2))/2.0)
		
	var time=rad_to_deg($sun.rotation.x+PI)
	if time<0:
		time+=360
	var minutes=time/360*24
	time=floor(time/360*24)
	minutes-=time
	minutes=minutes*60
	
	strtime=str(time)+":"+str(round(minutes))
	
	

	#Color(0.047058, 0.254901, 0.607843)
	
	
		
func _exit_tree():
	Input.set_mouse_mode(0)
	
