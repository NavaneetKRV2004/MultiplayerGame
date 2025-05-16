extends Node3D


@export var team=''

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func scored():
	
	get_parent().get_parent().get_node("chat").add_text(team+" TEAM SCORED")
	
	

func _on_area_area_entered(area):
	
	
	if "flag" in area.name and area.get_parent().team!= team:
		print("nigga"+" "+area.name)
		scored()
		area.get_parent().die()
