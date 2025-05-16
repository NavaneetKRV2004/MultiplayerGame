extends Control

@export var rows:int =4
@export var columns:int =8
@export var margin:Vector2=Vector2(100,100)
@export var frozen:bool = false


var items:Array[item]=[]
var extra:item=item.new()

var slot=preload("res://UIslot.tscn")
var cub=preload("res://cube.tscn")

@onready var grid=%grid

class item:
	var item:Node
	var count:int
	func _init() -> void:
		self.item=null
		self.count=0
		print("hi")
	



signal dropped(item:Node,count:int)

func resize():
	$NinePatchRect.size=grid.size+margin
func _ready() -> void:
	grid.columns=columns
	
	for i in range(rows*columns):
	
		items.append(item.new())
		
		var temp= slot.instantiate()
		grid.add_child(temp)
		temp.index=i
		temp.manager=self
		
	update_textures()
	resize()


func add_item(item:Node,count:int) -> bool:
	for i in range(rows*columns):
		if items[i].item == null:
			items[i].item=item
			items[i].count=1
			update_textures()
			return true
		elif items[i].item.type==item.type and item.stackable:
			items[i].count+=1
			item.queue_free()
			update_textures()
			return true
		elif items[i].item.type == item.type and not item.stackable:
			continue
		elif items[i].item.type != item.type:
			continue
	
	return false
	
	
	
	
func _process(delta: float) -> void:
	resize()

	
func slot_clicked(index:int):
	if extra.item != null and items[index].item != null and items[index].item.type == extra.item.type and extra.item.stackable:
		items[index].count+=extra.count
		extra.count=0
		extra.item.queue_free()
		extra.item=null
		update_textures()
		return
		
	var temp=extra.item
	var num=extra.count
	
	extra.item=items[index].item
	extra.count=items[index].count
	items[index].item=temp
	items[index].count=num
	
	update_textures()
	
	

func update_textures():
	for i in range(rows*columns):
		if items[i].item != null:
			grid.get_child(i).fill(items[i].item.inventory_texture,items[i].count)
		else:
			grid.get_child(i).fill(null,0)


func _on_visibility_changed() -> void:
	if visible:
		pass
	else:
		pass
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		add_item(cub.instantiate(),1)
		
