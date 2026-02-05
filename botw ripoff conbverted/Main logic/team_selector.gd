extends StaticBody3D
@export var team:String="white"
@export var respawn_position:Vector3=position
func _ready() -> void:
	$Label3D.text+="\n"+team.to_upper()
	$Label3D.modulate=g.teams[team]
func interact(player_ref:player):
	player_ref.position=respawn_position
	player_ref.respawn_point=respawn_position
	player_ref.team=team
	
