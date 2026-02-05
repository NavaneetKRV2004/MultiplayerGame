extends items
@onready var material = $skinn.get_surface_override_material(0)
@export var spawn_object="res://entities/basic_enemy.tscn"
@export var spawn_time:float
@export var spawn:bool=false:
	set(new):
		spawn=new
		if not material:
			return
		if new:
			material.albedo_color="ff0f0f"
		else:
			material.albedo_color="ffffff"
@onready var spawn_thing=load(spawn_object)

func _ready():
	spawn=spawn
	super._ready()
	$Timer.wait_time=spawn_time
	
	$Timer.start()

@rpc("any_peer")
func interact(p=null):
	if multiplayer.is_server():
		spawn=not spawn
	else:
		interact.rpc_id(1)
		


func _on_timer_timeout():
	if spawn and multiplayer.is_server():
		var p =spawn_thing.instantiate()
		p.position=position+Vector3(randi_range(-10,10),20,randi_range(-10,10))
		p.name="creeper"+str(randi())
		add_sibling(p,true)
