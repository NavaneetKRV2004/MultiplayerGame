extends Node
const PORT_GAME:=7000
const PORT_HTTP:=8000
const void_level:int=-50


@export var world_types:Array=[
	["procedural","res://worlds/procedural.tscn",],
	["flat","res://worlds/block.tscn",],
	["parkour","res://worlds/parkour.tscn",],
	["bedwars","res://worlds/bedwars.tscn",],
	["pvp arena","res://worlds/pvpmap.tscn"],
	["Hide and Seek"],
	["Catch"],
	["Bomb it"],
	["CTF"]
	]
enum teams{
	RED,
	BLUE,
	GREEN,
	YELLOW
}

func _input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("fullscreen toggle"):
		var w=get_window()
		w.mode =Window.MODE_WINDOWED if w.mode ==Window.MODE_EXCLUSIVE_FULLSCREEN else Window.MODE_EXCLUSIVE_FULLSCREEN
		
enum DEBUG_MESSAGES_TYPE{
	MISC,
	COMBAT,
	LOGIN,
	SPAWN,
	GAME_EVENTS,
	GAME_DATA
}
func p(text,source:Node=null,type:DEBUG_MESSAGES_TYPE=DEBUG_MESSAGES_TYPE.MISC):
	var source_name=str(source.name) if source else "??".lpad(20)
	print(source_name.lpad(20),":\t",text)

@export var list_of_items:Dictionary={
	
	"basic sword":{
		"scene":"res://items/basic_sword.tscn",
		"stackable":false,
		"texture":null
	},
	"iron sword":{
		"scene":"res://items/iron_sword.tscn",
		"stackable":false,
		"texture":"res://items/iron_sword_slot.png"
	},
	"trident":{
		"scene":"res://items/trident.tscn",
		"stackable":false,
		"texture":"res://items/trident.png"
	},
	"arrow":{
		"scene":"res://items/arrow.tscn",
		"stackable":true,
		"texture":"res://items/arrowslot.png"
	},
	
	"bomb":{
		"scene":"res://items/bomb.tscn",
		"stackable":true,
		"texture":null
	},
	
	"bow":{
		"scene":"res://items/bow.tscn",
		"stackable":false,
		"texture":"res://items/bowslot.png"
	},
	
	"sniper_bow":{
		"scene":"res://items/sniper_bow.tscn",
		"stackable":false,
		"texture":"res://items/bowslot.png"
	},
	
	"chest":{
		"scene":"res://items/chest.tscn",
		"stackable":true,
		"texture":"res://items/chestslot.png"
	},
	
	"flag":{
		"scene":"res://items/flag.tscn",
		"stackable":true,
		"texture":"res://items/flagslot.png"
	},
	
	"flag base":{
		"scene":"res://items/flagbase.tscn",
		"stackable":true,
		"texture":null
	},
	
	"shield":{
		"scene":"res://items/shield.tscn",
		"stackable":false,
		"texture":"res://items/shieldslot.png"
	},
	
	"spawner":{
		"scene":"res://items/spawner.tscn",
		"stackable":true,
		"texture":null
	},
	
	"tree":{
		"scene":"res://items/tree.tscn",
		"stackable":true,
		"texture":"res://items/treeslot.png"
	},
	"wood_wall":{
		"scene":"res://items/wood_wall.tscn",
		"stackable":true,
		"texture":null
	},
	"wood_doorway":{
		"scene":"res://items/wood_doorway.tscn",
		"stackable":true,
		"texture":null
	}
	
}

	
