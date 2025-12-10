class_name Construction extends items


func _ready() -> void:
	replication_interval=5.0
	super._ready()
	
func _setHeld():
	
	var value= not get_parent() is World
	freeze=true
	held=value
	col.disabled=value
	
