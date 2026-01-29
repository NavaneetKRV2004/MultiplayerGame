@tool
extends Node
var saveData="user://savedata.txt"
var FOV:int=70
var Rend_Method:int=0#stored as index
var fps:=60    #stored as id
var MS:=150
var JS:=5
var Resolution:=720
var server_list:Array=["1","","",""]
var player_name:String=""
var skin:Color=Color("FFFFFF")
var cross_hair_size:=10
var cross_hair_type:=1

func to_dict() -> Dictionary:
	var d := {}
	for p in get_property_list():
		if p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE and not (p.name in ["saveData","arguments"]):
			d[p.name] = get(p.name)
	return d
func from_dict(d: Dictionary) -> void:
	for key in d:
		set(key, d[key])
func load_():
	var isfile:bool=FileAccess.file_exists(saveData)
	var file=FileAccess.open(saveData, FileAccess.READ)
	var js=null
	if isfile:
		js=JSON.parse_string(file.get_as_text())
		
	if (not js) or (js and not (js is Dictionary)):
		g.p("Settings file corrupted/doesn't exist",self,g.DEBUG_MESSAGES_TYPE.GAME_DATA)
		file=FileAccess.open(saveData,FileAccess.WRITE_READ)
		file.store_string(JSON.stringify(to_dict()))
		g.p("Writing data to settings file:\n "+JSON.stringify(  to_dict(), "\t"),self,g.DEBUG_MESSAGES_TYPE.GAME_DATA)
	else:
		from_dict(js)
		g.p("reading from file:\n"+JSON.stringify(js,"\t"),self,g.DEBUG_MESSAGES_TYPE.GAME_DATA)
		g.p("Settings file valid",self,g.DEBUG_MESSAGES_TYPE.GAME_DATA)





func save_():
	var file = FileAccess.open(saveData, FileAccess.WRITE_READ)
	file.store_string(JSON.stringify(to_dict(),"\t"))
	g.p("Writing data to settings file:\n "+JSON.stringify( to_dict(), "\t"),self,g.DEBUG_MESSAGES_TYPE.GAME_DATA)
		
	return
	
	#var cf=ConfigFile.new()
	#cf.set_value("rendering","renderer/rendering_method",$TabContainer/Video/Panel/VBoxContainer/Rmethod.get_item_text(settings["Rend Method"]))
	#cf.save("res://override.cfg")
	#Engine.set_max_fps(settings["fps"])
	

var arguments:Dictionary={}
func _ready():
	load_()
	for argument in OS.get_cmdline_args():
		if argument.contains("="):
			var key_value = argument.split("=")
			arguments[key_value[0].trim_prefix("--")] = key_value[1]
		else:
			# Options without an argument will be present in the dictionary,
			# with the value set to an empty string.
			arguments[argument.trim_prefix("--")] = ""
