extends Control
@onready var edit =$VBoxContainer/TextEdit
@onready var textbox=$VBoxContainer/Label

@export var world:Node
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
@rpc("any_peer","call_local")
func add_text(content,player_name="game"):
	textbox.text+="\n[color=000000]"+player_name+"[/color]: "+content
	$VBoxContainer/TextEdit.text=""
	
func add_error(content:String):
	textbox.text+="\n[color=FF0000]"+content+"[/color]"
	


func _on_text_edit_text_submitted(new_text):
	if not new_text[0]=="/":
		rpc("add_text",new_text,str(get_parent().multi.get_unique_id()))
		
	else:
		match new_text.get_slice(" ",0):
			"/spawn":
				pass
			"/team":
				if new_text.get_slice(" ",1) !="":
					get_parent().my_player.team=new_text.get_slice(" ",1)
					add_text("Changed team to "+get_parent().my_player.team)
				
func _input(event):
	if Input.is_action_just_pressed("mouse escape"):
		if Input.mouse_mode==0:
			hide()
		else:
			show()

	
func spawn(sp:String):
	
	var loaded_entity=load("res://items/"+sp.to_lower()+".tscn").instantiate()
	if not loaded_entity:
		add_error(sp+"is not a valid name")
	loaded_entity.position=world.my_player.position
	world.add_child(loaded_entity)
	add_text(sp+" spawned")
