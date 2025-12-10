extends items
@onready var lid=$box/Node3D
@export var closedpos=0.0
@export var openedpos=118.0

var contents=range(0,16)
var open=false

func _ready():
	super._ready()
	lid.rotation_degrees.z=closedpos

func interact():
	open=not open
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if open:
		lid.rotation_degrees.z=lerp(lid.rotation_degrees.z,openedpos,0.5)
	else:
		lid.rotation_degrees.z=lerp(lid.rotation_degrees.z,closedpos,0.5)
	
