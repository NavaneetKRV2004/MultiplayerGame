extends items
@onready var material = $skinn.get_surface_override_material(0)
@export var spawn_object="res://basic_enemy.tscn"
@export var spawn_time:float
@export var spawn:bool
@onready var spawn_thing=load(spawn_object)

func _ready():
	super._ready()
	$Timer.wait_time=spawn_time
	
	$Timer.start()
	
func interact():
	spawn=not spawn
	if spawn:
		material.albedo_color="ff0f0f"
	else:
		material.albedo_color="ffffff"


func _on_timer_timeout():
	if spawn:
		var p =spawn_thing.instantiate()
		p.position=position+Vector3(randi_range(-10,10),20,randi_range(-10,10))
		
		add_sibling(p,true)
