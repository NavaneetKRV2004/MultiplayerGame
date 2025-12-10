@tool
extends Node2D

@onready var heart_node = $"screen/topleft/0"
var max_hearts=20
var current_hearts=20
@export var vspacing=20
@export var hspacing=20
@export var alpha=1.0
@export var flickering=false
@onready var refs=[]
var parent:Node=null
var prevHealth:int=0


func _health():
	var life:int=0
	if get_parent() is player:
		life=ceili(80.0*parent.health/parent.maxHealth)
	else:
		life = 80
	if life>80:
		push_error("Player maxHealth lesser than Health")
	
	if prevHealth!=0 and life < prevHealth:
		$AnimationPlayer.play("flicker")
		prevHealth=life
	
	for i in refs:
		if life>=4:
			i.frame=0
			life-=4
		elif 0<=life and life<4:
			i.frame=4-life
			life=0
			
				
		
func _ready():
	parent=get_parent()
	var start_pos=heart_node.position
	var nodevar
	refs.append(heart_node)
	
	for i in range(current_hearts-1):
		nodevar=heart_node.duplicate()
		refs.append(nodevar)
		$screen/topleft.add_child(nodevar)
	for i in range(len(refs)):
		refs[i].position=start_pos+Vector2((i%10)*hspacing,i/10*vspacing)
		

	
	
func _physics_process(_delta):
	_health()
	if flickering:
		for i in refs:
			if i.frame==4:
				i.modulate.a=alpha
