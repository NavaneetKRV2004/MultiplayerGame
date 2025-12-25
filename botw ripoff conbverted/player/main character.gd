class_name player extends CharacterBody3D
#load-------------------------------------
var arrow=preload("res://items/arrow.tscn")
var bomb=preload("res://items/bomb.tscn")
#path-----------------------------
@onready var camera=$body/head/Camera3D
@onready var ray:RayCast3D = $body/head/ray
@onready var anim = $AnimationPlayer
@onready var arrow_point=$body/head/Arrowpoint

#player-------------------------------------------------------
@export var Player_name:StringName="stupid name"
@export var health:float=80.0
@export var maxHealth:float=80.0
@export var state:String="melee"
@export var gamemode_survival:bool=true
@export var team:g.teams=g.teams.RED
@export var input_enabled:bool=true
@export var deaths:int=0
##world------------------------------------------------------------
@export_group("World")
@export var player_world:World
@export var respawn_point:Vector3=Vector3(0,150,0)


@export_group("Appearance")
@export var hair:Color=Color(0,0,0)
@export var skin:Color=Color(1,0.322,0.322)
@export var pants:Color=Color(0,0,0)
@export var face:int=0
@export var shirt:int=0

#INVENTORY----------------------------------------------------------
@export_group("Inventory")
var inv:Array=[]
var hotbar_index=0
@export var inventory:Inventory
@export var my_selection_wheel:Node


#MOVEMENT------------------------------------------------------------
@export_group("Movement")
var lerped_player_movement=Vector3.ZERO
@export var speed=10
var boost=1
@export var pushforce=10
var knockback_force:Vector3=Vector3(0,0,0)

@export var position2:Vector3=Vector3(0,0,0)
@export var gravity=0.5

var player_input_component:Vector3=Vector3.ZERO
var gravity_component:Vector3=Vector3.ZERO

@export var handpos:Vector3


func get_held_item()->items:
	var count:int=$armjoint/hand.get_child_count()
	if count>1:
		push_error("Multiple items held in right hand")
		return $armjoint/hand.get_child(0)
	elif count == 1:
		return $armjoint/hand.get_child(0)
	else:
		return null
		
func setHotbarIndex(i:int):
	hotbar_index=i
	if hotbar_index>=8 or hotbar_index<0:
		push_error("hotbar_index out of bounds")
		hotbar_index=clamp(hotbar_index,0,7)
	
	if get_held_item():
		get_held_item().reset()
		$armjoint/hand.remove_child(get_held_item())
			
	if inventory.getItemAt(hotbar_index):
		$armjoint/hand.add_child(inventory.getItemAt(hotbar_index))
		#g.p("Holding %s"%get_held_item().item_name,self)

func _get_facing_direction():
	return ($body/head/Arrowpoint.global_position-camera.global_position).normalized()


func attack(a:bool,attack_boost_multiplier=1):
	var temp=get_held_item()
	if temp and temp.has_method("swing"):
		temp.weapon_owner=self
		temp.swing(a,attack_boost_multiplier)
	
@rpc("call_local")
func attacksound():
	$AudioStreamPlayer3D.play(0.28)


	
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
func play(a,backwards=false,duration=1.0):
	var neg=-1 if backwards else 1
	if anim.current_animation != a:
		resetanim()
		anim.play(a,-1,neg*(1/duration),backwards)

@rpc("any_peer","call_local")
func damage(n:float=0.0,   kb:float=0.0,   global_source_position:Vector3=Vector3(0,0,0)    ):
	if is_multiplayer_authority():
		health-=n
		g.p(Player_name+" got damaged (-"+str(floor(n))+")",self,g.DEBUG_MESSAGES_TYPE.COMBAT)
		camera.start_shake()
		knockback_force= (global_position-global_source_position).normalized()*kb
	else:
		$GPUParticles3D.emitting=true

	

@rpc("call_local","authority")
func respawn():
	deaths+=1
	position=respawn_point
	velocity=Vector3.ZERO
	health=maxHealth
	player_world.chat.add_text("[b][color=green]%s[/color][/b] died"%Player_name)
	for i in get_children(false):
		if i is Arrow:
			i.queue_free()




func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
func _ready():
	var bow:Bow=$"bow placement".get_child(0)
	if not bow:
		push_error("No bow at spawn")
	else:
		bow.my_player=self
		
	player_world=get_parent()
	if not is_multiplayer_authority():
		$ui.queue_free()
		$DebugData.queue_free()
		inventory.queue_free()
		$healthbara.show()
	else:
		camera.current=true
		$healthbara.queue_free()
		inventory.hide()
		
		inv.clear()
		inv.append_array(
		[
			load("res://items/iron_sword.tscn").instantiate(),
			load("res://items/trident.tscn").instantiate(),
			load("res://items/basic_sword.tscn").instantiate(),
			load("res://items/tree.tscn").instantiate(),
			load("res://items/arrow.tscn").instantiate(),
			load("res://items/sniper_bow.tscn").instantiate()
		]
		)
		for i in inv:
			i.name=i.item_name+str(randi())
			if i is Arrow:
				inventory.add_item(i,10)
			else:
				inventory.add_item(i,1)
			
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.default()
	
	
	for i in inv:
		if "weapon_owner" in i:
			i.weapon_owner=self
			

	setHotbarIndex(0)
	ray.add_exception(self)
	
	
func _physics_process(_delta):
	
	if not is_multiplayer_authority():
	
		return
	if position.y<g.void_level-50:
		rpc("respawn")
		
	position2=position
	
	if health<=0:
		rpc.call("respawn")
	if Input.is_action_just_pressed("mouse escape"):
		player_world.chat.visible=not player_world.chat.visible
		
		
	if inventory.visible or my_selection_wheel.visible or player_world.chat.open or player_world.options.visible:
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
		input_enabled=true
		
	
	if not player_world.chat.open:
		if not my_selection_wheel.visible:
			if Input.is_action_just_pressed("inventory"):
				if get_held_item():
					get_held_item().reset()
				inventory.visible=not inventory.visible
				input_enabled=not inventory.visible
				if not inventory.visible:
					setHotbarIndex(hotbar_index)
		if not inventory.visible:
			if Input.is_action_just_pressed("select wheel"):
				my_selection_wheel.show()
				if get_held_item():
					get_held_item().reset()
			if Input.is_action_just_released("select wheel"):
				my_selection_wheel.hide()
	else:
		input_enabled=false
			
	
	if input_enabled:
		$body.visible=camera.perspective!=1
		if Input.is_action_just_pressed("perspective"):
			
			camera.perspective=0 if camera.perspective==1 else 1
			
			
		
			
		
			
#region mouse item interactions
		if Input.is_action_just_pressed("lmb"):
			var col=ray.get_collider()
			state="melee"

			if get_held_item():
				get_held_item().interactJustPressedLMB(self,col)
			else:
				if col is player:
					col.damage.rpc(2,100,global_position)
					play("hit",false)
		if Input.is_action_just_released("lmb"):
			var col=ray.get_collider()
			state="melee"
			if get_held_item():
				get_held_item().interactReleasedLMB(self,col)
			
		if Input.is_action_just_pressed("rmb"):
			var col=ray.get_collider()
			state="melee"
			if col is items and col.has_method("interact"):
				col.interact()
			elif get_held_item():
				get_held_item().interactJustPressedRMB(self,col)
				
		if Input.is_action_just_released("rmb"):
			var col=ray.get_collider()
			state="melee"
			if get_held_item():
				get_held_item().interactReleasedRMB(self,col)
				
#endregion

		if Input.is_action_just_released("pick up"):
			var col=ray.get_collider()
			if col and col is items and col.collectable and not col.held and inventory.isAddable(col):
				inventory.add_item(col,1)
				col.delete_copies()
				player_world.remove_child(col)
				
				
		if Input.is_action_just_pressed("drop"):
			var item:items =inventory.subtract_item(hotbar_index)
			if item:
				
				if item.get_parent():
					item.reparent(player_world)
				else:
					player_world.add_child(item)
				item.global_position= arrow_point.global_position
					
				player_world.item_spawner.make_copies(item)
		if Input.is_action_just_pressed("shield"):
			rpc("play","shield")
			state="melee"
		elif Input.is_action_just_released("shield"):
			rpc("play","shield",true)
			
		boost = 2 if Input.is_action_pressed("boost") else 1
			
		if Input.is_action_just_pressed("gamemode_survival"):
			gamemode_survival=not(gamemode_survival)

		
			
	
	player_input_component=Vector3.ZERO
	if not gamemode_survival:
		if input_enabled:
			player_input_component.y = boost*speed*(-int(Input.is_action_pressed("shift"))+int(Input.is_action_pressed("space")))
		gravity_component.y=0
	else:
		if is_on_floor():
			gravity_component.y=0
		else:
			gravity_component.y=clamp(gravity_component.y-gravity,-300,300)
			
		if Input.is_action_just_pressed("space") and input_enabled and (is_on_floor() or $GroundDetection.get_collider()):
			gravity_component.y = 30
				
	
	
	if input_enabled:
		if Input.is_action_pressed("w"):
			player_input_component.x+=cos(deg_to_rad(-get_rotation_degrees().y))*speed*boost
			player_input_component.z+=sin(deg_to_rad(-get_rotation_degrees().y))*speed*boost
		if Input.is_action_pressed("a"):
			player_input_component.x+=cos(deg_to_rad(-get_rotation_degrees().y-90))*speed*boost
			player_input_component.z+=sin(deg_to_rad(-get_rotation_degrees().y-90))*speed*boost
		if Input.is_action_pressed("s"):
			
			player_input_component.x+=-cos(deg_to_rad(-get_rotation_degrees().y))*speed*boost
			player_input_component.z+=-sin(deg_to_rad(-get_rotation_degrees().y))*speed*boost
		if Input.is_action_pressed("d"):
			player_input_component.x+=cos(deg_to_rad(-get_rotation_degrees().y+90))*speed*boost
			player_input_component.z+=sin(deg_to_rad(-get_rotation_degrees().y+90))*speed*boost
		camera.isWobbling=not player_input_component.is_zero_approx()
		camera.isRunning= boost != 1
		
	lerped_player_movement=lerp(lerped_player_movement,player_input_component,0.1)
	#knockback_force.y=clampf(knockback_force.y,-1.0,7.0)
	knockback_force *=0.99
	velocity  = gravity_component+ knockback_force+lerped_player_movement 
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
	$"body/head/head model".get_surface_override_material(0).albedo_color=skin
	if not is_multiplayer_authority(): 
		position=lerp(position,position2,0.1)
		return
	rotate_y(delta*s.settings.JS*(int(Input.is_action_pressed("look right"))-int(Input.is_action_pressed("look left"))))
	$body/head.rotate_z(delta*s.settings.JS*(int(Input.is_action_pressed("look up"))-int(Input.is_action_pressed("look down"))))
	if $body/head.rotation_degrees.x >0:
		$body/head.rotation_degrees.x=0
	
#	elif $body/head.rotation_degrees.z<-90:
#		$body/head.rotation_degrees.z=-90
	
	

func _input(event):
	
	if not is_multiplayer_authority() or not input_enabled:
		return
	if Input.is_action_just_pressed("escape"):
		
		player_world.options.visible=not player_world.options.visible
		
	if Input.is_action_just_pressed("zoom"):
		camera.perspective=2
	elif Input.is_action_just_released('zoom'):
		camera.default()
	
	
	if event is InputEventMouseMotion and Input.get_mouse_mode()==2:
		rotate_y(-event.get_relative().x*s.settings.MS/22500.0)
		$body/head.rotate_z(-event.get_relative().y*s.settings.MS/22500.0)
		
	#if Input.is_action_just_pressed("reload map"):
		#damage(0,100,arrow_point.global_position)

	
func update_debug():
	
	
	
	if $DebugData.visible:
		var c:int =get_slide_collision_count()
		var l:Array=[]
		for i in range(c):
			var obj:Node=get_slide_collision(i).get_collider()
			if  obj is items:
				l.append(obj.item_name)
			else:
				l.append(obj.name)
		var d=player_world.item_spawner.sync_items
		var d1={}
		for i in d:
			if d[i] in d1:
				d1[d[i]]+=1
			else:
				d1[d[i]]=1
		
		var held_item= get_held_item()
		

		
	
		var debug=[
		
		"FPS: %d/%d  %.2fms"%[Engine.get_frames_per_second(),Engine.get_physics_ticks_per_second(),RenderingServer.viewport_get_measured_render_time_gpu(get_viewport().get_viewport_rid())],
		"RAM: %d MB"%[OS.get_static_memory_usage()/1000000,],
		"Player: %s (%s)"%[Player_name,name],
		"Health: %d/%d"%[health,maxHealth],
		"Coordinates: (%d,%d,%d)"%[position.x,position.y,position.z],
		"Velocity: (%d,%d,%d)"%[velocity.x,velocity.y,velocity.z],
		"\tgravity_component: (%d %d %d)\n\tknockback_force: (%d,%d,%d,)\n\tLerped_player_movement: (%d,%d,%d)"%[gravity_component.x,gravity_component.y,gravity_component.z,knockback_force.x,knockback_force.y,knockback_force.z,lerped_player_movement.x,lerped_player_movement.y,lerped_player_movement.z],
		"Velocity Magnitude: "+str(round(velocity.length()*100.0)/100.0),
		"Gamemode: "+"Survival" if gamemode_survival else "Creative",
		"Time: "+player_world.strtime,
		"FOV: "+str(ceil(camera.fov)), 
		"Perspective: "+str(camera.perspective),
		"Default Perspective: "+str(camera.default_perspective),
		"hotbar index: %d\tItem: %s"%[hotbar_index,held_item.item_name if held_item else "Nil"],
		"\t"+"\n\t".join(held_item.debug()) if held_item else "",
		"colliding with: [%d]\n%s"%[c,l],
		"Items on ground: "+str(d1),
		"Pointed Object's Authority: "+str(ray.get_collider().get_multiplayer_authority()) if ray.get_collider() else "",
		]
	
			
		$DebugData.text="[color=BLACK][b]"+"\n".join(debug)+"[/b][/color]"
