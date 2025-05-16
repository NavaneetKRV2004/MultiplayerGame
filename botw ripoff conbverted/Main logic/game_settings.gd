extends Node
var f=0
var saveData="user://savedata.txt"
var settings={
	"Limit Fps":60,
	"Mouse Sensitivity":150,
	"Joystick Sensitivity":5,
	"Physics Fps":60,
	"Resolution":720
	}
	
func getvalues():
	var v=[]
	for i in settings.keys():
		v.append(get_node("VBoxContainer/"+i).value)
	print("got values from slides ",v)
	return v
			
func save(nvalues):
	
	var b=settings.keys()
	var set={}
	for i in range(len(settings)):
		set[b[i]]=nvalues[i]
	
		
	var file = FileAccess.open(saveData, FileAccess.WRITE_READ)
	file.store_string(JSON.stringify(set))
	print("saved",set)
	

func lloaddict():
	var file=FileAccess.open(saveData, FileAccess.READ)
	if file == null:
		file=FileAccess.open(saveData,FileAccess.WRITE_READ)
		file.store_string(JSON.stringify(settings))
		return settings
	else:
		var cont=file.get_as_text()
	
		return JSON.parse_string(cont)
	
	
	

	
	
func _ready():
	return
	print(settings)
	var v=lloaddict()
	print("values loaded are",v)
	
	var n=0
	for i in settings.keys():
		get_node("VBoxContainer/"+i).value=v[i]
		print("VBoxContainer/"+i," changed to", v[i])
		n+=1
		
		


func _on_button_2_button_down():
	var v =[60,150,5,60]
	save(v)
	var n=0
	for i in settings.keys():
		get_node("VBoxContainer/"+i).value=v[n]
		n+=1


func _exit_tree():
	return
	save(getvalues())
	
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("fullscreen toggle"):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (not ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
	if Input.is_action_just_pressed("mouse escape"):
		
		Input.set_mouse_mode(2*int(not bool(Input.mouse_mode/2)))



func _on_button_3_button_up():
	if ProjectSettings.get_setting("rendering/renderer/rendering_method")=="forward_plus":
		ProjectSettings.set_setting("rendering/renderer/rendering_method","mobile")
	else:
		ProjectSettings.set_setting("rendering/renderer/rendering_method","forward_plus")
	$Button3.text=ProjectSettings.get_setting("rendering/renderer/rendering_method")
