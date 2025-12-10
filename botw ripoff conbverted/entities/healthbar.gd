extends Sprite3D

var parent:player=null


func _ready() -> void:
	parent=get_parent()
##Updates health bar percentage to a 
func _physics_process(_delta):
	if not parent:
		return
	var a:float= 100.0*parent.health/parent.maxHealth
	a=clamp(a,0.0,100.0)
	$Sprite3D.region_rect.position.x=lerp(47.0,106.0,(100.0-a)/100.0)
	$Label3D.text=parent.Player_name
	
