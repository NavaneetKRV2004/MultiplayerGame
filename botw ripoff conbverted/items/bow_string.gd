extends Node3D
@export var upper:Node
@export var lower:Node

@export_range(0.0,1.0) var progress:float=0:
	set(val):
		progress=val
		if upper and lower:
			upper.position=Vector3(0,half_length,extend_till*progress)/2.0
			lower.position=Vector3(0,-half_length,extend_till*progress)/2.0
			upper.rotation.x=-atan2(extend_till*progress,half_length)
			lower.rotation.x=-atan2(extend_till*progress,-half_length)
			upper.scale.y=Vector2(half_length,extend_till*progress).length()
			lower.scale.y=Vector2(half_length,extend_till*progress).length()
		
@export var half_length:float=0.0

@export var extend_till:float=1.0
