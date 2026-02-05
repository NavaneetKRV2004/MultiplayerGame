extends StaticBody3D
class_name Procedural
@export var generate:bool:
	set(value):
		_ready()
@export var chunkSize:int = 300
@export var subdivide:int = 42
@export var amplitude:int = 50
@export var material:Material
@export var noise=FastNoiseLite.new()
@export var mountains=FastNoiseLite.new()
var Vmax:float=0.0
var chunks:Array[MeshInstance3D]=[]
var cols:Array[CollisionShape3D]=[]
var chunkVector={}
@onready var world:World=get_parent()

var tree=preload("res://items/tree.tscn")
var chunkLoadTimes:Array=[]
var totalChunksLoaded:=0
func setup_chunk(mesh: MeshInstance3D) -> void:
	var plane := PlaneMesh.new()
	plane.size = Vector2(chunkSize, chunkSize)
	plane.subdivide_width = subdivide
	plane.subdivide_depth = subdivide
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane,0)
	surface_tool.generate_normals()
	mesh.mesh = surface_tool.commit()
	mesh.rotation = Vector3.ZERO
	
	
	
func _ready():
	cols.clear()
	chunks.clear()
	var index=0
	for i in get_children():
		if i is MeshInstance3D:
			chunks.append(i)
			setup_chunk(i)
	for i in get_children():
		if i is CollisionShape3D:
			cols.append(i)
			
	
	for i in [-1,0,1]:
		for j in [-1,0,1]:
			chunks[index].position.x=i*chunkSize
			chunks[index].position.z=j*chunkSize
			chunkVector[Vector2(i,j)]=chunks[index]
			generateChunk(chunks[index])
			cols[index].shape=chunks[index].mesh.create_trimesh_shape()
			cols[index].position=chunks[index].position
			index+=1

var centerChunk:=Vector2.ZERO
func _process(delta: float) -> void:
	if world is WorldClient and not world.my_player:
		return
		
	var temp1
	if world is WorldServer:
		temp1=floor(Vector2(world.server_camera.position.x,world.server_camera.position.z)/chunkSize)
	else:
		temp1=floor(Vector2(world.my_player.position.x,world.my_player.position.z)/chunkSize)
	
	if temp1==centerChunk:
		return
	else:
		centerChunk=temp1
	
	
	
	#Removing chunks
	var removedChunks=[]
	for i in chunkVector.keys():
		if (i.distance_squared_to(centerChunk)>2.1):
			removedChunks.append(chunkVector[i])
			chunkVector.erase(i)
			
			
	#Adding chunks
	
	for i in [-1,0,1]:
		for j in [-1,0,1]:
			if removedChunks.is_empty():
				return
			if  not (centerChunk+Vector2(i,j)) in chunkVector:
				var temp:MeshInstance3D=removedChunks.pop_back()
				temp.position.x=(centerChunk.x+i)*chunkSize
				temp.position.z=(centerChunk.y+j)*chunkSize
				generateChunk(temp)
				var corresponding_col=get_node("c"+str(temp.name)[-1])
				corresponding_col.shape=temp.mesh.create_trimesh_shape()
				corresponding_col.position=temp.position
				chunkVector[Vector2(centerChunk.x+i,centerChunk.y+j)]=temp
				
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reload map"):
		_ready()
		
func get_height_at(coords:Vector2)->float:
	return coords.x*coords.y*0.1

func isInLoadedChunk(xz:Vector2):
	return (xz/chunkSize).floor() in chunkVector
	

func generateChunk(mesh: MeshInstance3D):
	var t0=Time.get_ticks_usec()
	var array_mesh := mesh.mesh as ArrayMesh
	if not array_mesh:
		chunkLoadTimes.append(-1)
		return 0
	
	# Get surface data
	var arrays = array_mesh.surface_get_arrays(0)
	var vertices: PackedVector3Array = arrays[ArrayMesh.ARRAY_VERTEX]

	for i in vertices.size():
		var v := vertices[i]

		# World-space sampling (important for tiling)
		var wx = v.x + mesh.global_position.x
		var wz = v.z + mesh.global_position.z

		var h = (noise.get_noise_2d(wx, wz) + 1.0) * 0.5 * amplitude
		v.y = h
		vertices[i] = v

		#if multiplayer.is_server() and h / amplitude > 0.25 and randi() % 10 == 0:
			#var t = tree.instantiate()
			#t.position = Vector3(wx, h, wz)
			#t.rotation.y = randf_range(-PI, PI)
			#add_sibling(t)

	# Write back vertices
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices

	# Rebuild mesh
	array_mesh.clear_surfaces()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	# Recalculate normals
	var st := SurfaceTool.new()
	st.create_from(array_mesh, 0)
	st.generate_normals()
	mesh.mesh = st.commit()

	# Update collision
	#mesh.get_child(0).shape = mesh.mesh.create_trimesh_shape()
	#if not mesh.get_child(0):
		#printerr("NO COLLISOIN")
	#mesh.get_child(0).position.y+=20
	chunkLoadTimes.append((Time.get_ticks_usec()-t0)/1000)
	totalChunksLoaded+=1


func debug():
	if chunkLoadTimes.size()>9:
		chunkLoadTimes.pop_front()
	return ["Chunk Times (recent 9/" + str(totalChunksLoaded)+") : "+("ms ".join(chunkLoadTimes.map(str)))+"ms",]
	
	
