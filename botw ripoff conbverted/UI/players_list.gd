extends Control
var world
func _ready() -> void:
	world=get_parent()
	assert(world is World)
func _process(delta: float) -> void:
	if Input.is_action_pressed("player list"):
		visible=true
	if Input.is_action_just_released("player list"):
		visible=false
		
	if visible:
		$VBoxContainer/Label2.text="Players " +str(len(world.players))
		$VBoxContainer/Panel/Label.text=""
		for i in world.players:
			if world.players[i]:
				$VBoxContainer/Panel/Label.text+=world.players[i].Player_name+(" [color=GREEN](you)[/color]" if world.players[i]==world.my_player else "")+"\n"
