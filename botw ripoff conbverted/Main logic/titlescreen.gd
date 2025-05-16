extends Control
@export var world_client:StringName="res://worlds/world_client.tscn"
@export var world_server:StringName="res://worlds/world_server.tscn"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_button_2_button_down():
	$CanvasLayer/Control2.show()

func client():
	get_tree().change_scene_to_file(world_client)

func server():
	get_tree().change_scene_to_file(world_server)
