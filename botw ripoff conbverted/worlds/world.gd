extends Node3D
class_name World

@export var player_scene:String ="res://player/main character.tscn"
@export var item_spawner:MultiplayerSpawner
var Player = load(player_scene)
 
@export_group("World Settings")
@export var world_name="World"
@export var world_type:int
@export var default_gamemode:int
@export var worldspawn:Vector3=Vector3(0,50,0)
@export var ren=20
@export var timeperiod:float = 200.0
@export var pvp:bool=true
@export var time:float=0.0
var strtime:String


var players:Dictionary={}
var my_player:player=null



var multi=null
var id
var selected_IP=""


@export var chat:Node


func spawn_player(peer_id:int) -> player:
	if peer_id==1: return
	var mc=Player.instantiate()
	
	mc.name=str(peer_id)
	mc.position=worldspawn
	add_child(mc)
	
	players[peer_id]=mc
	return mc
	
	


func delete_player(peer_id:int):
	
	if peer_id==1:
		multi.close()
		get_tree().change_scene_to_file("res://Main logic/disconnected.tscn")
		return
	chat.add_text(players[peer_id].Player_name+" disconnected")
	
	var child=get_node_or_null(str(peer_id))
	if child:
		child.queue_free()
	players.erase(peer_id)
	
			
func _ready():
	RenderingServer.viewport_set_measure_render_time(get_viewport().get_viewport_rid(),true)
	var fil=FileAccess.open("user://savedata.txt",FileAccess.READ)
	var cont=fil.get_as_text()
	var nj=JSON.parse_string(cont)
	Engine.max_fps=nj["fps"]
	fil.close()
	
	child_entered_tree.connect(item_dropped_on_ground)
	
func item_dropped_on_ground(child:Node):
	if child is items and child is not Arrow:
		child.set_multiplayer_authority(1)
		
	

	
	
	
	

	
func _physics_process(delta):
	if Input.is_key_pressed(KEY_HOME):
		if multi:
			multi.close()
		get_tree().change_scene_to_file("res://Main logic/titlescreen.tscn")
	
	
	if timeperiod!=0:
		$sun.rotate_x(deg_to_rad(360.0/timeperiod * delta))
#		$WorldEnvironment.environment.sky.sky_material.sky_top_color=lerp(Color(0.325490, 0.564705, 0.980392),Color(0,0,0),(1+sin($sun.rotation.x-PI/2))/2.0)
		
	time=rad_to_deg($sun.rotation.x+PI)
	if time<0:
		time+=360
	var minutes=time/360*24
	time=floor(time/360*24)
	minutes-=time
	minutes=minutes*60
	
	strtime="%d:%d"%[time,round(minutes)]
	
	

	#Color(0.047058, 0.254901, 0.607843)
	

		
func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse escape"):
		Input.set_mouse_mode(2 if Input.mouse_mode==0 else 0)
		
