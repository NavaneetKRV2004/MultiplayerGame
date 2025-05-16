extends Control


var saveData="user://savedata.txt"
var Dsettings={
	"FOV":70,
	"Rend Method":0, #stored as index
	"fps":60,     #stored as id
	"MS":150,
	"JS":5,
	"Resolution":720
	}
	
var settings=[]
func load_dict():
	var file=FileAccess.open(saveData, FileAccess.READ)
	if file == null:
		file=FileAccess.open(saveData,FileAccess.WRITE_READ)
		file.store_string(JSON.stringify(Dsettings))
		return Dsettings
	else:
		var js=JSON.parse_string(file.get_as_text())
	
		return js
		
func _ready():
	
	settings=load_dict()
	$TabContainer/Video/Panel/VBoxContainer/Rmethod.select(settings["Rend Method"])
	$TabContainer/Video/Panel/VBoxContainer/fps.select($TabContainer/Video/Panel/VBoxContainer/fps.get_item_index(settings["fps"]))
	$TabContainer/Video/Panel/VBoxContainer/fov.value=settings["FOV"]
	$TabContainer/Controls/Panel/VBoxContainer/ms.value=settings["MS"]
	$TabContainer/Controls/Panel/VBoxContainer/js.value=settings["JS"]

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_button_button_down():
	hide()


func _on_button_2_button_down():
	var file = FileAccess.open(saveData, FileAccess.WRITE_READ)
	file.store_string(JSON.stringify(settings))
	
	var cf=ConfigFile.new()
	cf.set_value("rendering","renderer/rendering_method",$TabContainer/Video/Panel/VBoxContainer/Rmethod.get_item_text(settings["Rend Method"]))
	cf.save("res://override.cfg")
	Engine.set_max_fps(settings["fps"])
	


func _on_rmethod_item_selected(index):
	settings["Rend Method"]=index


func _on_fps_item_selected(index):
	settings["fps"]=$TabContainer/Video/Panel/VBoxContainer/fps.get_item_id(index)


func _on_fov_drag_ended(_value_changed):
	settings["FOV"]=$TabContainer/Video/Panel/VBoxContainer/fov.value


func _on_ms_drag_ended(value_changed):
	settings["MS"]=$TabContainer/Controls/Panel/VBoxContainer/ms.value
	


func _on_js_drag_ended(value_changed):
	settings["JS"]=$TabContainer/Controls/Panel/VBoxContainer/js.value
