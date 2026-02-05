extends Node
const PORT_GAME:=7000
const PORT_HTTP:=8000
const void_level:int=-200


@export var world_types:Array=[
	["Island","res://worlds/island.tscn",],
	["Flat","res://worlds/block.tscn",],
	["Parkour","res://worlds/parkour.tscn",],
	["Bedwars","res://worlds/bedwars.tscn",],
	["Pvp arena","res://worlds/pvpmap.tscn"],
	["Castle snipers","res://worlds/castle_snipers.tscn"],
	["Early dev land","res://worlds/land.tscn"],
	["Procedural","res://worlds/procedural.tscn"],
	["Hide and Seek"],
	["Catch"],
	["Bomb it"],
	["CTF"],
	["Spleef"],
	]

var teams={
	"white":Color.WHITE,
	"red":Color.RED,
	"blue":Color.BLUE,
	"orange":Color.ORANGE,
	"green":Color.GREEN
}


var particles:Dictionary={
	"bomb":"res://particles/bomb_particles.tscn"
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
	
var list_of_entities:Dictionary={
	"creeper":{
		"scene":"res://entities/basic_enemy.tscn"
	}
}

@export var list_of_items:Dictionary={
	
	"basic sword":{
		"scene":"res://items/basic_sword.tscn",
		"stackable":false,
		"texture":"res://items/basic_sword_slot.png"
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
		"stackable":false,
		"texture":"res://items/bomb_slot.png"
	},
	
	"bow":{
		"scene":"res://items/bow.tscn",
		"stackable":false,
		"texture":"res://items/bowslot.png"
	},
	
	"sniper_bow":{
		"scene":"res://items/sniper_bow.tscn",
		"stackable":false,
		"texture":"res://items/sniper_bow_slot.png"
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
		"texture":"res://items/wall_slot.png"
	},
	"wood_doorway":{
		"scene":"res://items/wood_doorway.tscn",
		"stackable":true,
		"texture":"res://items/door_way_slot.png"
	},
	"wood_floor":{
		"scene":"res://items/wood_floor.tscn",
		"stackable":true,
		"texture":"res://items/door_way_slot.png"
	},
	"glass":{
		"scene":"res://items/glass.tscn",
		"stackable":true,
		"texture":"res://items/glass_glass.png"
	},
	"wood_door":{
		"scene":"res://items/wooden_door.tscn",
		"stackable":true,
		"texture":"res://items/wood_door_tex1_64x128_A9D1055D669D31C4_12_mip0.png"
	}
	
}

	
