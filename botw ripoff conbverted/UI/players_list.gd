extends Control
var world:World
func _ready() -> void:
	world=get_parent()
	assert(world is World)
func _process(delta: float) -> void:
	visible= Input.is_action_pressed("player list") or world.teams
	
		
	if visible:
		$VBoxContainer/Label2.text="Players " +str(len(world.players))
		$VBoxContainer/Panel/Label.text=""
		var teams_dict:Dictionary={}
		if world.teams:
			for i in world.players:
				if world.players[i]:
					var temp_team:String=world.players[i].team
					if temp_team in teams_dict:
						teams_dict[temp_team].append(i)
					else:
						teams_dict[temp_team]=[i,]
			for i in teams_dict:
				$VBoxContainer/Panel/Label.text+="[color=%s]%s[/color]\n"%[i.to_upper(),i.to_upper()]
				for j:int in teams_dict[i]:
					$VBoxContainer/Panel/Label.text+=world.players[j].Player_name+(" [color=GREEN](you)[/color]" if world.players[j]==world.my_player else "")+"\n"

		else:
			for i in world.players:
				if world.players[i]:
					$VBoxContainer/Panel/Label.text+=world.players[i].Player_name+(" [color=GREEN](you)[/color]" if world.players[i]==world.my_player else "")+"\n"
