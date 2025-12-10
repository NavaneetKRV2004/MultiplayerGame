@tool
extends Control
var saveData="user://savedata.txt"
class Dsettings:
	var FOV:int=70
	var Rend_Method:int=0#stored as index
	var fps:=60    #stored as id
	var MS:=150
	var JS:=5
	var Resolution:=720
	var server_list:Array=["1","","",""]
	var player_name:String=""
	var skin:Color=Color("FFFFFF")
	
	func loadFromDictionary(d:Dictionary)-> void:
		
		FOV=d.FOV
		Rend_Method=d.Rend_Method
		fps=d.fps
		MS=d.MS
		JS=d.JS
		Resolution=d.Resolution
		server_list=d.server_list
		player_name=d.player_name
		skin=d.skin
	func saveToDictionary()->Dictionary:
		var d={}
		d.FOV=FOV
		d.Rend_Method=Rend_Method
		d.fps=fps
		d.MS=MS
		d.JS=JS
		d.Resolution=Resolution
		
		d.server_list=server_list
		d.player_name=player_name
		d.skin=skin	
		return d
		
		
var arguments:Dictionary={}
var settings:Dsettings=Dsettings.new()
func load_():
	var file=FileAccess.open(saveData, FileAccess.READ)
	if file:
		var js=JSON.parse_string(file.get_as_text())
		if not js or js and not js is Dictionary:
			g.p("Settings file corrupted",self,g.DEBUG_MESSAGES_TYPE.GAME_DATA)
		else:
			settings.loadFromDictionary(js)
			g.p("reading from file:\n"+JSON.stringify(js,"\t"),self,g.DEBUG_MESSAGES_TYPE.GAME_DATA)
			g.p("Settings file valid",self,g.DEBUG_MESSAGES_TYPE.GAME_DATA)
			
	else:
		file.close()
		file=FileAccess.open(saveData,FileAccess.WRITE_READ)
		file.store_string(JSON.stringify(settings.saveToDictionary()))
		g.p("Writing data to settings file:\n "+JSON.stringify(  settings.saveToDictionary(), "\t"),self,g.DEBUG_MESSAGES_TYPE.GAME_DATA)
		
		
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



func save_():
	var file = FileAccess.open(saveData, FileAccess.WRITE_READ)
	file.store_string(JSON.stringify(settings.saveToDictionary()))
	g.p("Writing data to settings file:\n "+JSON.stringify(  settings.saveToDictionary(), "\t"),self,g.DEBUG_MESSAGES_TYPE.GAME_DATA)
		
	return
	
	var cf=ConfigFile.new()
	cf.set_value("rendering","renderer/rendering_method",$TabContainer/Video/Panel/VBoxContainer/Rmethod.get_item_text(settings["Rend Method"]))
	cf.save("res://override.cfg")
	Engine.set_max_fps(settings["fps"])
	
