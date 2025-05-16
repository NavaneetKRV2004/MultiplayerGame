extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@rpc("call_local")
func playname(a):
	$Label.text=a
	
	
