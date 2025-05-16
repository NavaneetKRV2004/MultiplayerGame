extends Node2D
var heart_node = preload("res://UI/hearts.tscn")
var max_hearts=20
var current_hearts=20
@export var alpha=1.0
@export var flickering=false
@onready var refs=[]


func health(life1:float):
	var life=int(roundi(life1))
	$AnimationPlayer.play("flicker")
	
	if life>80:
		life=80
	elif life<0:
		life=0
		
	var l =life
	
	for i in refs:
		
		if l>=4:
			i.frame=0
			l=l-4
		elif l<4 and l in [3,2,1,0]:
			i.frame=4-l
			l=0
			
				
		
func _ready():
	var start_pos=Vector2(5,5+randi_range(1,10))
	var pos =Vector2(start_pos)
	var nodevar
	var spacing=20
	
	for i in range(0,current_hearts):
		nodevar=heart_node.instantiate()
		refs.append(nodevar)
		nodevar.position=pos
		if i==9:
			pos=(start_pos+Vector2(0,15))
		else:
			pos=pos+Vector2(spacing,0)
		$topleft.add_child(nodevar)

	
	
func _physics_process(delta):
	if flickering:
		for i in refs:
			if i.frame==4:
				i.modulate.a=alpha
func hotbar_select(n):
	var b=$screen/Control4/Panel/HSplitContainer
	for i in b.get_children():
		i.disabled=false
	b.get_child(n-1).disabled=true
