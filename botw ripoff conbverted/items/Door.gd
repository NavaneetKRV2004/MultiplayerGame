extends Construction
class_name Door
@export var open:bool=false:
	set(value):
		open=value
		if value:
			nodeIfMultipleMesh.position=Vector3(1,0,1)
			nodeIfMultipleMesh.rotation=Vector3(0,-PI/2,0)
			col.position=Vector3(1,1.5,1)
			col.rotation=Vector3(0,-PI/2,0)
		else:
			nodeIfMultipleMesh.position=Vector3.ZERO
			nodeIfMultipleMesh.rotation=Vector3(0,0,0)
			col.position=Vector3(0,1.5,0)
			col.rotation=Vector3(0,0,0)

@rpc("any_peer")
func interact(p:player=null):
	if not multiplayer.is_server():
		interact.rpc_id(1)
		return 
	else:
		open=not open
