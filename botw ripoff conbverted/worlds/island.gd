@tool
extends StaticBody3D
@export var generate:bool:
	set(value):
		_ready()
@export var size:int = 1000
@export var subdivide:int = 128
@export var amplitude:int = 50
@export var ocean:Node
@export var ocean_level:float=0:
	set(value):
		if Engine.is_editor_hint():
			ocean.position.y=value
			ocean_level=value
		
@export var material:Material
@export var noise=FastNoiseLite.new()
@export var mountains=FastNoiseLite.new()
@export var falloff:Curve
@export var falloffAmplitude:float=50
var Vmax:float=0.0



var tree=preload("res://items/tree.tscn")

func _ready():
	
	#g.p("Generating Mesh...")
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size,size)
	plane_mesh.subdivide_depth = subdivide
	plane_mesh.subdivide_width = subdivide
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh,0)
	var data = surface_tool.commit_to_arrays()
	var vertices = data[ArrayMesh.ARRAY_VERTEX]
	
	for i in vertices.size():
		Vmax=max(vertices[i].x,Vmax)
		
	
	for i in vertices.size():
		var vertex = vertices[i]
		var placement =(noise.get_noise_2d(vertex.x,vertex.z)+1)/2.0*amplitude
		placement*=    falloff.sample( max(abs(vertex.x),abs(vertex.z))/Vmax   ) 
		vertices[i].y = placement
		
		if not Engine.is_editor_hint() and multiplayer.is_server() and placement/amplitude>0.25 and not bool(randi_range(0,10)):
			var s=tree.instantiate()
			s.position=Vector3(vertex.x,placement,vertex.z)
			s.rotation.y=randi_range(-180,180)
			s.name="tree"+str(randi())
			add_sibling(s)
		
		
		
		
	data[ArrayMesh.ARRAY_VERTEX] = vertices
		
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,data)
	
	surface_tool.create_from(array_mesh,0)
	surface_tool.generate_normals()

	$MeshInstance.mesh = surface_tool.commit()
	$CollisionShape.shape = array_mesh.create_trimesh_shape()
	$MeshInstance.rotation_degrees=Vector3(0,0,0)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reload map"):
		_ready()
