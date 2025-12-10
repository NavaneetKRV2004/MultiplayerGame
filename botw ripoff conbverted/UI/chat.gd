extends Control
@onready var edit =$VBoxContainer/TextEdit
@onready var textbox=$VBoxContainer/Label
@export var open:bool=false

func setOpen(value):
	open=value
	$VBoxContainer/TextEdit.visible=value
	if value:
		$VBoxContainer/TextEdit.edit()
	else:
		$VBoxContainer/TextEdit.unedit()

@export var world:World=null


	
@rpc("any_peer","call_local")
func add_text(content,player_name="game"):
	textbox.text+="\n[color=000000]"+player_name+"[/color]: "+content
	$VBoxContainer/TextEdit.text=""
	
func add_error(content:String):
	textbox.text+="\n[color=FF0000]"+content+"[/color]"
	


func _on_text_edit_text_submitted(new_text:String):
	if not new_text[0]=="/":
		rpc("add_text",new_text,world.my_player.Player_name)
		
	else:
		var args:Array=new_text.split(" ")
		match args[0]:
			"/spawn":
				if args[1] in g.list_of_items:
					rpc_id(1,"spawn",args[1],world.my_player.position)
				else:
					add_error(args[1]+" is not a valid name")
			"/team":
				if new_text.get_slice(" ",1) !="":
					get_parent().my_player.team=new_text.get_slice(" ",1)
					add_text("Changed team to "+get_parent().my_player.team)
				


@rpc("any_peer","call_remote")
func spawn(sp:String,pos:Vector3):
	
	var loaded_entity:items=load(g.list_of_items[sp]["scene"]).instantiate()
	
	loaded_entity.name=loaded_entity.item_name+str(randi())
	loaded_entity.position=pos+Vector3(0,50,0)
	world.add_child(loaded_entity)
	add_text(sp+" spawned")
