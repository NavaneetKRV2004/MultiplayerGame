extends Node2D

@onready var heart_node = $"screen/topleft/0"
var max_hearts=20
var current_hearts=20
@export var vspacing=20
@export var hspacing=20
@export var alpha=1.0
@export var flickering=false
@onready var refs=[]
var parent:player=null
var prevHealth:int=0
@export var arrow_count:Label
var crosshair_texture_index:int=0
var crosshair_size:float=10:
	set(val):
		val=clamp(val,10,100)
		$screen/CenterContainer/crosshair.custom_minimum_size=Vector2(val,val)
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
	crosshair_size= s.settings.cross_hair_size
	var table:Array=[
		Vector2(0,0),
		Vector2(100,0),
		Vector2(0,100),
		Vector2(100,100),
		Vector2(0,200)
		]
	var position_rect=table[s.settings.cross_hair_type-1]
	$screen/CenterContainer/crosshair.texture.region=Rect2(position_rect,Vector2(100,100))
	$screen/topleft.visible=parent and parent.gamemode_survival
	_health()
	if flickering:
		for i in refs:
			if i.frame==4:
				i.modulate.a=alpha
	
	if parent.get_held_item() is Bow and not parent.inventory.visible:
		var index=parent.inventory.getFirstArrowIndexInInventory()
		arrow_count.text= str(parent.inventory.inventory[index].count)
		arrow_count.show()
	else:
		arrow_count.hide()
			
