extends CanvasLayer

@export_group("server buttons")
@export var localhostbutton:ServerButton
@export var LANButton:ServerButton
@export var MS1button:ServerButton
@export var MS2button:ServerButton
@export var MS3button:ServerButton

@export var LANtextbox:SpinBox
@export var MS1textbox:TextEdit
@export var MS2textbox:TextEdit
@export var MS3textbox:TextEdit

@export_group("player")
@export var player_name:TextEdit
@export var skin:ColorPickerButton



	
func _ready() -> void:
	
	LANtextbox.value=int(s.settings.server_list[0])
	MS1textbox.text=s.settings.server_list[1]
	MS2textbox.text=s.settings.server_list[2]
	MS3textbox.text=s.settings.server_list[3]

	
func check_servers():
	localhostbutton.ask_server()
	#LANButton.ask_server()
	#MS1button.ask_server()
	#MS2button.ask_server()
	#MS3button.ask_server()
	#
func save_ip_addresses():
	s.settings.server_list[0]=str(int(LANtextbox.value))
	s.settings.server_list[1]=MS1textbox.text
	s.settings.server_list[2]=MS2textbox.text
	s.settings.server_list[3]=MS3textbox.text

	


func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://Main logic/titlescreen.tscn")
