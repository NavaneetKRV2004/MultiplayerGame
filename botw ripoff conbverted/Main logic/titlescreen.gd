extends Node3D
@export var world_client:StringName="res://worlds/world_client.tscn"
@export var world_server:StringName="res://worlds/world_server.tscn"
@export var options:Control# Called when the node enters the scene tree for the first time.
func _ready():
	if "--server" in OS.get_cmdline_args():
		get_window().mode=Window.MODE_MINIMIZED
		server.call_deferred()
	elif "--client" in OS.get_cmdline_args():
		get_window().mode=Window.MODE_EXCLUSIVE_FULLSCREEN
		client.call_deferred()
	



func _on_button_2_button_down():
	$CanvasLayer/Control2.show()

func client():
	get_tree().change_scene_to_file(world_client)

func server():
	get_tree().change_scene_to_file(world_server)
func toggle_settings():
	options.visible=not options.visible
func glossary():
	get_tree().change_scene_to_file("res://glossary.tscn")
	
func play_ui_sound():
	$CanvasLayer/Control/AudioStreamPlayer.play(0.0)
func quit():
	get_tree().quit()
