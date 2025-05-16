extends StaticBody3D


@export var size:int = 500
@export var subdivide:int = 32
@export var amplitude:int = 50

@export var noise=FastNoiseLite.new()
@export var mountains=FastNoiseLite.new()

var tree=preload("res://items/tree.tscn")

func _ready():
	
	print("Generating Mesh...")
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size,size)
	plane_mesh.subdivide_depth = subdivide
	plane_mesh.subdivide_width = subdivide
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(plane_mesh,0)
	var data = surface_tool.commit_to_arrays()
	var vertices = data[ArrayMesh.ARRAY_VERTEX]
	
	
	
	for i in vertices.size():
		var vertex = vertices[i]
		var placement = noise.get_noise_2d(vertex.x,vertex.z) * amplitude
		vertices[i].y = placement
		if placement<0.4*amplitude and placement>0.3 and bool(randi_range(0,1)):
			var s=tree.instantiate()
			s.position=Vector3(vertex.x,placement,vertex.z)
			s.rotation.y=randi_range(-180,180)
			add_child(s)
		
		
		
		
	data[ArrayMesh.ARRAY_VERTEX] = vertices
		
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,data)
	
	surface_tool.create_from(array_mesh,0)
	surface_tool.generate_normals()

	$MeshInstance.mesh = surface_tool.commit()
	$CollisionShape.shape = array_mesh.create_trimesh_shape()
	$MeshInstance.rotation_degrees=Vector3(0,0,0)
