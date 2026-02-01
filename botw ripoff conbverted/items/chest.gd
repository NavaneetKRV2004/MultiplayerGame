extends Construction
@onready var lid=$Node3D/box/Node3D
@export var closedpos=0.0
@export var openedpos=118.0

var contents=range(0,16)
@export var open=false

func _ready():
	super._ready()
	lid.rotation_degrees.z=closedpos

@rpc("any_peer")
func interact():
	if not multiplayer.is_server():
		interact.rpc_id(1)
		return 
	else:
		open=not open


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if open:
		lid.rotation_degrees.z=lerp(lid.rotation_degrees.z,openedpos,0.5)
	else:
		lid.rotation_degrees.z=lerp(lid.rotation_degrees.z,closedpos,0.5)
	
