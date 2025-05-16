extends Node


const world_types={
	0:"res://worlds/procedural.tscn",
	1:"res://worlds/block.tscn",
	2:"res://worlds/parkour.tscn",
	3:"res://bedwars.tscn"
	}
enum teams{
	RED,
	BLUE,
	GREEN,
	YELLOW
}

const void_level:int=-50



func _input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("fullscreen toggle"):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (not ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
	if Input.is_action_just_pressed("mouse escape"):
		
		Input.set_mouse_mode(2*int(not bool(Input.mouse_mode/2)))
