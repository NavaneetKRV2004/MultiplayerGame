extends Node
@onready var placement=$CanvasLayer/HBoxContainer/SubViewportContainer/SubViewport/Node3D
@onready var grid:GridContainer = $CanvasLayer/HBoxContainer/Panel/GridContainer
@onready var camera:Camera3D=$CanvasLayer/HBoxContainer/SubViewportContainer/SubViewport/Camera3D
var slot=preload("res://UI/UIslot.tscn")
var list=g.list_of_items.duplicate()
var item_list:Array[items]=[]
@export var zoomFactor:int=20
var positionZ:float
var positionY:float
func _ready() -> void:
	positionY=placement.position.y
	positionZ=placement.position.z
	list.sort()
	var index=0
	for i in list:
		var temp:items=load(list[i]["scene"]).instantiate()
		item_list.append(temp)
		var temp2=slot.instantiate()
		grid.add_child(temp2)
		temp2.index=index
		temp2.manager=self
		temp2.fill(temp.inventory_texture,1)
		
		
		index+=1
	slot_clicked(0)
	
	
func slot_clicked(index:int):
	if placement.get_child(0):
		placement.remove_child(placement.get_child(0))
	placement.add_child(item_list[index])
	
	var col=placement.get_child(0).col
	placement.position.y=positionY-col.position.y
		
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("scroll up"):
		positionZ+=delta*zoomFactor
	if Input.is_action_just_pressed("scroll down"):
		positionZ-=delta*zoomFactor
	positionZ=clamp(positionZ,-100,-1)

	placement.position.z=lerp(placement.position.z,positionZ,0.5)
	

func _input(event: InputEvent) -> void:	
	if event is InputEventMouseMotion and Input.is_action_pressed("lmb"):
			placement.rotate_y(event.get_relative().x*s.settings.MS/2250.0)

func _on_back_button_up() -> void:
	get_tree().change_scene_to_file("res://Main logic/titlescreen.tscn")
