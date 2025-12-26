class_name Construction extends items

@export var held_size_ratio:float=0.2

	
func _setHeld():
	
	var value= not get_parent() is World
	freeze=true
	held=value
	col.disabled=value
	
	if held:
		for i in get_children():
			if i is MeshInstance3D:
				i.scale=Vector3(held_size_ratio,held_size_ratio,held_size_ratio)
	else:
		for i in get_children():
			if i is MeshInstance3D:
				i.scale=Vector3(1,1,1)
	
