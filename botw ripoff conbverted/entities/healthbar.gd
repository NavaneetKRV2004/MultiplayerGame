extends Sprite3D

var n=0
func update(a:float):
	a=clamp(a,0.0,100.0)
	$Sprite3D.region_rect.position.x=lerp(47.0,106.0,(100.0-a)/100.0)
	
	
