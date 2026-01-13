extends Control
@onready var edit =$VBoxContainer/TextEdit
@onready var textbox=$VBoxContainer/Label
@export var open:bool=false:
	set(value):
		open=value
		if not edit:
			return
		edit.visible=value
		if value:
			edit.edit()
		else:
			edit.unedit()
			edit.text=""
			check_if_chat_should_disappear_and_do()
			

@export var world:World=null


	
@rpc("any_peer","call_local")
func add_text(content,player_name="game"):
	textbox.text+="\n[color=000000]"+player_name+"[/color]: "+content
	visible=true
	check_if_chat_should_disappear_and_do()
	
func add_error(content:String):
	textbox.text+="\n[color=FF0000]"+content+"[/color]"
	visible=true
	check_if_chat_should_disappear_and_do()
	


func _on_text_edit_text_submitted(new_text:String):
	if not new_text[0]=="/":
		rpc("add_text",new_text,(world.my_player.Player_name) if world is WorldClient else ("[color=FF0000]<Server>[/color]"))
		edit.edit()
		
	else:
		if not world.ischeatsEnabled:
			add_error("Cheats disabled")
			return
		var args:PackedStringArray=new_text.split(" ")
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
			"/tp":
				if args.size()==4:
					if args[1].is_valid_int():
						world.my_player.position.x=int(args[1])
					
					if args[2].is_valid_int():
						world.my_player.position.y=int(args[2])
					
					if args[3].is_valid_int():
						world.my_player.position.z=int(args[3])
	edit.text=""
					
						
					


@rpc("any_peer","call_remote")
func spawn(sp:String,pos:Vector3):
	
	var loaded_entity:items=load(g.list_of_items[sp]["scene"]).instantiate()
	
	loaded_entity.name=loaded_entity.item_name+str(randi())
	loaded_entity.position=pos+Vector3(0,50,0)
	world.add_child(loaded_entity)
	add_text(sp+" spawned")

func check_if_chat_should_disappear_and_do():
	if visible and not edit.visible:
		$Timer.start(3)
	


func _on_timer_timeout() -> void:
	if not edit.visible:
		visible=false
