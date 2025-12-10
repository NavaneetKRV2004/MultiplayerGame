extends items



@export var team:String=''
@export var spawnpoint:Node

func _ready():
	super._ready()
	return
	spawnpoint=get_parent()
	team=spawnpoint.team
	$Cube.mesh.surface_set_material(0,$Cube.mesh.surface_get_material(0).duplicate() )
	var p
	match team:
		"r":
			p=Color(1,0,0)
		"g":
			p=Color(0,1,0)
		"y":
			p=Color(1, 0.843137, 0, 1)
		"b":
			p=Color(0,0,1)
	$Cube.mesh.surface_get_material(0).albedo_color=p
	
func die():
	reparent(spawnpoint)
	position=Vector3.ZERO

#albedo_color Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_area_3d_body_entered(body):
	if body is player:
		
		if body.team !=team and (not body == get_parent()):
			reparent(body)
		elif body.team==team and position != Vector3.ZERO:
			die()
