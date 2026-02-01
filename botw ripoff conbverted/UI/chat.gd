extends Control
@onready var edit:LineEdit =$VBoxContainer/TextEdit
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
const affirmative:Array = ["1","true","on"]
const negative:Array = ["0","false","off"]

	
@rpc("any_peer","call_local")
func add_text(content,player_name="[color=FF0000]<Server>[/color]"):
	textbox.text+="\n[color=000000]"+player_name+"[/color]: "+content
	visible=true
	check_if_chat_should_disappear_and_do()
	
func add_error(content:String="Invalid Syntax"):
	textbox.text+="\n[color=FF0000]"+content+"[/color]"
	visible=true
	check_if_chat_should_disappear_and_do()
	


func _on_text_edit_text_submitted(new_text:String):
	if not new_text[0]=="/":
		if world is WorldClient:
			rpc("add_text",new_text,world.my_player.Player_name)
		else:
			rpc("add_text",new_text)
		edit.edit()
		
	else:
		if not new_text.begins_with("/save") and not world.ischeatsEnabled:
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
				if args[1].to_lower() in g.teams:
					world.my_player.team=args[1]
					var temp=args[1].to_upper()
					add_text("Changed team to [color=%s]%s[/color]"%[temp,temp])
				else:
					add_error("Invalid team.\nTeams: "+str(g.teams.keys()))
			"/tp":
				if args.size()==4:
					if args[1].is_valid_int():
						world.my_player.position.x=int(args[1])
					
					if args[2].is_valid_int():
						world.my_player.position.y=int(args[2])
					
					if args[3].is_valid_int():
						world.my_player.position.z=int(args[3])
			"/save":
				rpc("add_text","Saving...","[color=FF0000]<Server>[/color]")
				if len(args)==1:
					rpc_id(1,"askServerToSave")
				else:
					rpc_id(1,"askServerToSave",args[1] )
					
			"/gamerule","/gr":
				if len(args)==3:
					gamerule(args[1],args[2])
				else:
					add_error()
			_:
				add_error("No such command")
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
@rpc("any_peer","reliable")
func askServerToSave(save_as:String="new_world"): 
	if world is WorldServer and is_multiplayer_authority():
		world.save_world(save_as)


func gamerule(property:String,value:String):
	property= property.to_lower()
	value=value.to_lower()
	match property:
		"pvp":
			if value in affirmative:
				_change_gamerule.rpc_id(1,"pvp",true)
			elif value in negative:
				_change_gamerule.rpc_id(1,"pvp",false)
			else:
				add_error("Value should be Boolean")
		"gm","gamemode":
			if value in ["0","1"]:
				_change_gamerule.rpc_id(1,"default_gamemode",value.to_int())
			else:
				add_error("Value should be valid Int")
		"teams","t":
			if value in affirmative:
				_change_gamerule.rpc_id(1,"teams",true)
			elif value in negative:
				_change_gamerule.rpc_id(1,"teams",false)
			else:
				add_error("Value should be Boolean")
		_:
			add_error("No such gamerule")

	
@rpc("any_peer","call_remote")
func _change_gamerule(rule,value):
	world.set(rule,value)
	rpc("add_text","Gamerule "+rule+" changed to "+str(value))
		
