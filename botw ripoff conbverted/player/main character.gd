class_name player extends CharacterBody3D
#load-------------------------------------
var arrow=preload("res://items/arrow.tscn")
var bomb=preload("res://items/bomb.tscn")
#path-----------------------------
@onready var camera=$body/head/Camera3D
@onready var ray = $body/head/ray
@onready var anim = $AnimationPlayer


#player-------------------------------------------------------
@export var Player_name:StringName="stupid name"
@export var health:float=80.0
@export var state:String="melee"
@export var gamemode_survival:bool=true
@export var team:global.teams=0

##world------------------------------------------------------------
@export_group("World")
@export var world:Node
@export var respawn_point:Vector3=Vector3(0,50,0)


@export_group("Appearance")
@export var hair:Color=Color(0,0,0)
@export var skin:Color=Color(0,0,0)
@export var pants:Color=Color(0,0,0)
@export var face:int=0
@export var shirt:int=0

#INVENTORY----------------------------------------------------------
var inventory:Dictionary={}
var hotbar_index=0

#MOVEMENT------------------------------------------------------------
@export_group("Movement")
var vxy=Vector2.ZERO
@export var speed=10
var boost=1
@export var pushforce=10
var kb={"dir":Vector3.ZERO,"mag":0}
@export var position2:Vector3=Vector3(0,0,0)
@export var gravity=0.5


#controls
var js=5
var ms=100



@export var handpos:Vector3


func get_held_item():
	if $armjoint/hand.get_child_count() != 0:
		return $armjoint/hand.get_child(0)
	else:
		return null
		
@rpc("call_local")
func change_weapon(forward_backward):
	
	print("------*------")
	if hotbar_index==8 and forward_backward or hotbar_index==1 and not forward_backward:
		pass
	else:
		
		hotbar_index=hotbar_index+(int(forward_backward)*2-1)
		print(hotbar_index)
		
		if get_held_item() != null:
			print("removing "+str(get_held_item().name))
			$armjoint/hand.remove_child(get_held_item())
			
		if inventory[hotbar_index] != null:
			$armjoint/hand.add_child(inventory[hotbar_index])
			print("adding "+str(get_held_item().name))
			
#	$ui.hotbar_select(hotbar_index)
	
	
@rpc("call_local")
func shoot_arrow(arr_speed_scale=1.0):
	
	var rr = arrow.instantiate()
	rr.rotation_degrees.x=90
	#rr.arro_owner=name
	$body/head/Arrowpoint.add_child(rr)
	rr.linear_velocity=($body/head/Arrowpoint.global_position-$body/head.global_position).normalized()*50*arr_speed_scale
	rr.reparent(get_parent())
	rr.set_physics_process(true)
	$armjoint/hand.show()
	
	camera.default()
	speed=speed*2

@rpc("call_local")
func throw_bomb():
	var bm = bomb.instantiate()
	bm.position=position+Vector3(0,3,0)
	bm.linear_velocity=Vector3(10*cos(deg_to_rad(-get_rotation_degrees().y)),2,10*sin(deg_to_rad(-get_rotation_degrees().y)))
	add_sibling(bm)
	bm=null


func attack(a:bool,attack_boost_multiplier=1):
	if get_held_item() !=null:
		get_held_item().weopon_owner=name
		get_held_item().swing(a,attack_boost_multiplier)
	
@rpc("call_local")
func attacksound():
	$AudioStreamPlayer3D.play(0.28)
@rpc("call_local")
func withdraw():
	$"bow placement".get_child(0).withdraw(1)
	
func disable_col(a):
	#$armjoint/hand.get_child(0).col_toggle(a)
	$"bow placement".get_child(0).col_toggle(a)
	$armjoint2/hand.get_child(0).col_toggle(a)
	
func resetanim():
	
	$armjoint2.rotation_degrees=Vector3(15.6,1.8,-16.4)
	$armjoint/hand.position=Vector3(0.845,0,0)
	$armjoint/hand.rotation_degrees=Vector3(0,0,0)
	$armjoint2.rotation_degrees=Vector3(15.6,1.8,-16.4)
	$armjoint2/hand.rotation_degrees=Vector3(-15.2,78.4,-3.0)
	$armjoint2/hand.position=Vector3(0.844,0,0)
	$"bow placement".position=Vector3(-0.596,0.33,0)
	$"bow placement".rotation_degrees=Vector3(0,-90,-30)

@rpc("call_local")	
func play(a,backwards=false):
	var neg=1
	if backwards:
		neg=-1
	else:
		neg=1
	if anim.current_animation != a:
		resetanim()
		anim.play(a,-1,neg,backwards)

@rpc("call_local")
func damage(n:float):
	
	rpc("update_health",(health-n))
	$GPUParticles3D.emitting=true
	
@rpc("call_local")
func update_health(h):
	health=h
	$ui.health(health)
	$healthbara.update(health/80.0*100.0)
	

@rpc("call_local","authority")
func respawn():
	position=respawn_point
	velocity=Vector3.ZERO
	health=80.0
	if is_multiplayer_authority():
		$ui.health(health)
		$healthbara.update(health/80.0*100)
	for i in get_children(false):
		print(i)
		if "@bruh" in i.name:
			
			i.queue_free()


func update_looks():
	pass

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
func _ready():
	
	world=get_parent()
	if not is_multiplayer_authority():
		$ui.queue_free()
		$DebugData.queue_free()
		$healthbara.show()
	else:
		$healthbara.hide()
	Input.set_mouse_mode(2)
	camera.default()
	#$crosshair.position=get_window().size/2
	
	for i in range(16):
		inventory[i+1]=null
		
		
	inventory[1]=load("res://items/iron_sword.tscn").instantiate()
	inventory[2]=load("res://items/trident.tscn").instantiate()
	inventory[3]=load("res://items/basic_sword.tscn").instantiate()
	
	
	
	for i in range(16):
		if inventory[i+1] != null and "weopon_owner" in inventory[i+1]:
			inventory[i+1].weopon_owner=name
			inventory[i+1].col_toggle(false)
			#print(inventory[i+1].name)
	change_weapon(true)
	
	
	
func _physics_process(delta):
	
	
	if position.y<global.void_level-50:
		rpc("respawn")
	
	if not is_multiplayer_authority():
		position=lerp(position,position2,0.1)
		return
	position2=position
	if health<=0:
		rpc.call("respawn")
	
	if Input.is_action_just_pressed("bow"):
		if not state=="bow":
			rpc("play","bow")
		$"bow placement".get_child(0).withdraw(1)
		
#		var rr = arrow.instantiate()
#		rr.rotation_degrees.x=90
#		$body/head/Arrowpoint.add_child(rr)
		#rr.set_physics_process(false)
		
		
		camera.perspective=3
		speed=speed/2.0
		state="bow"
		
		
	if Input.is_action_just_released("bow"):
		rpc("shoot_arrow",$"bow placement".get_child(0).withdraw_completion/100)
		$"bow placement".get_child(0).release(1)
		
		
	if Input.is_action_just_pressed("bomb"):
		rpc("throw_bomb")
	
		
	if Input.is_action_just_released("lmb"):
		var col=ray.get_collider()
		
		if not (col != null and col.has_method("interact")):
			state="melee"
			if is_on_floor():
				rpc("play","attack_h")
				
			else:
				rpc("play","attack_v")
		else:
	
			col.interact()
		
	if Input.is_action_just_pressed("shield"):
		rpc("play","shield")
		state="melee"
	elif Input.is_action_just_released("shield"):
		rpc("play","shield",true)
	if Input.is_action_pressed("boost"):
		boost=2
	else:
		boost=1
	if Input.is_action_just_pressed("gamemode_survival"):
		gamemode_survival=not(gamemode_survival)
		
		
	if Input.is_action_just_released("scroll up"):
		print("uo")
		rpc("change_weapon",true)
	elif Input.is_action_just_released("scroll down"):
		rpc("change_weapon",false)
		print("down")
			

	if gamemode_survival==false:
		velocity.y = boost*speed*(-int(Input.is_action_pressed("shift"))+int(Input.is_action_pressed("space")))
	else:
		if is_on_floor():
			velocity.y=0
			if Input.is_action_just_pressed("space"):
				velocity.y = 30
		else:
			if velocity.y<-300:
				velocity.y=-300
			elif velocity.y>300:
				velocity.y=300
			else:
				velocity.y-=gravity
	var Tvelocity=Vector3()
	Tvelocity.x=0
	Tvelocity.z=0
	
	if Input.is_action_pressed("w"):
		Tvelocity.x+=cos(deg_to_rad(-get_rotation_degrees().y))
		Tvelocity.z+=sin(deg_to_rad(-get_rotation_degrees().y))
	if Input.is_action_pressed("a"):
		Tvelocity.x+=cos(deg_to_rad(-get_rotation_degrees().y-90))
		Tvelocity.z+=sin(deg_to_rad(-get_rotation_degrees().y-90))
	if Input.is_action_pressed("s"):
		
		Tvelocity.x+=-cos(deg_to_rad(-get_rotation_degrees().y))
		Tvelocity.z+=-sin(deg_to_rad(-get_rotation_degrees().y))
	if Input.is_action_pressed("d"):
		Tvelocity.x+=cos(deg_to_rad(-get_rotation_degrees().y+90))
		Tvelocity.z+=sin(deg_to_rad(-get_rotation_degrees().y+90))
		
		
		
	vxy=lerp(vxy,Vector2(Tvelocity.x,Tvelocity.z).normalized()*speed*boost,0.1)
	
	kb.mag-=0.4
	kb.mag=clampf(kb.mag,0.0,100.0)
	
	
	velocity=Vector3(vxy.x,velocity.y, vxy.y)+kb.dir*kb.mag
	
	
		

	set_up_direction(Vector3.UP)
	
	
	var cc=get_slide_collision_count()
	if false: #cc>0 #kicking rigid bodies
		var a=get_slide_collision(cc-1)
		var b=a.get_collider()
		
		
		if b is items:
			if b.COLLECTABLE==false:
				pass
			else:
				b.apply_impulse((b.position-position).normalized()*pushforce)
	
	
		
	
	move_and_slide()
	
	update_debug()
	
	
func _process(delta):
	rotate_y(delta*js*(int(Input.is_action_pressed("look right"))-int(Input.is_action_pressed("look left"))))
	$body/head.rotate_z(delta*js*(int(Input.is_action_pressed("look up"))-int(Input.is_action_pressed("look down"))))
	if $body/head.rotation_degrees.x >0:
		$body/head.rotation_degrees.x=0
	
#	elif $body/head.rotation_degrees.z<-90:
#		$body/head.rotation_degrees.z=-90
	if Input.is_action_just_pressed("perspective"):
		
		camera.perspective=(camera.perspective+1)%2
		visible=int(not bool(camera.perspective))

func _input(event):
	if not is_multiplayer_authority(): return
	if Input.is_action_just_pressed("zoom"):
		camera.perspective=3
	elif Input.is_action_just_released('zoom'):
		camera.default()
	
	
	if event is InputEventMouseMotion and Input.get_mouse_mode()==2:
		rotate_y(-event.get_relative().x*ms/22500.0)
		$body/head.rotate_z(-event.get_relative().y*ms/22500.0)
		
		

	
func update_debug():
	if $DebugData.visible:

		var debug=["FPS: "+str(floor(Engine.get_frames_per_second()))+" / "+str(floor(Engine.get_physics_ticks_per_second())),
		"Health: "+str(health),
		"Coordinates: (" + str(floor(position.x)) + ",     " + str(floor(position.y)) + ",      "+str(floor(position.z))+")",
		"Velocity: ("+str(floor(velocity.x)) + "   ," + str(floor(velocity.y)) + "   ," + str(floor(velocity.z)) + "     )",
		"Velocity Magnitude: "+str(round(velocity.length()*100.0)/100.0),
		"Gamemode: "+"survival" if gamemode_survival else "creative",
		"Time: "+world.strtime,
		"Rendering Radius: "+str(world.ren),
		"FOV: "+str(ceil(camera.fov)), 
		"Perspective: "+str(camera.perspective),
		"Default Perspective: "+str(camera.default_perspective),
		"hotbar index: "+str(hotbar_index),
		"inventory: "+str(inventory)]
	
			
		$DebugData.text="\n".join(debug)
