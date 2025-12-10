extends Construction


@export var team=''




func scored():
	
	get_parent().get_parent().get_node("chat").add_text(team+" TEAM SCORED")
	
	

func _on_area_area_entered(area):
	
	
	if "flag" in area.name and area.get_parent().team!= team:
		g.p("Scored"+" "+area.name,self,g.DEBUG_MESSAGES_TYPE.GAME_EVENTS)
		scored()
		area.get_parent().die()
