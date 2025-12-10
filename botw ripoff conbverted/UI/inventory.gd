
extends Control
class_name Inventory
@export var rows:int =4
@export var columns:int =8
@export var margin:Vector2=Vector2(100,100)
@export var frozen:bool = false


var inventory:Array[item]=[]
var extra:item=item.new()

var slot=preload("res://UI/UIslot.tscn")


@onready var grid=%grid

class item:
	var item:Node
	var count:int
	
	func _init() -> void:
		self.item=null
		self.count=0
	
	


signal slot_selected(item:Node,count:int)
signal dropped(item:Node,count:int)

func _resize():
	$NinePatchRect.size=grid.size+margin
	size=$NinePatchRect.size
	
	position =get_viewport_rect().size/2-size / 2
	
	
func _ready() -> void:
	grid.columns=columns
	
	for i in range(rows*columns):
	
		inventory.append(item.new())
		
		var temp= slot.instantiate()
		grid.add_child(temp)
		temp.index=i
		temp.manager=self
		
	update_textures()
	_resize()


	
	
	
	#
func _process(_delta: float) -> void:
	if visible and not frozen :
		$cursor.position=get_local_mouse_position()-Vector2(10,10)

	


func _on_visibility_changed() -> void:
	
	if visible and len(inventory)==rows*columns:
		_resize()
		
		update_textures()
	

		
func getItemAt(i:int) -> Node:
	return inventory[i].item
func add_item(item:Node,count:int) -> bool:
	assert(count>0,"Tried to add item with count %d (should be non-zero positive integer)"%count)
		
	for i in range(rows*columns):
		if inventory[i].item == null:
			inventory[i].item=item
			
			inventory[i].count=count
			update_textures()
			return true
		elif inventory[i].item.item_name==item.item_name and item.stackable:
			inventory[i].count+=count
			item.queue_free()
			update_textures()
			return true
		elif inventory[i].item.item_name == item.item_name and not item.stackable:
			continue
		elif inventory[i].item.item_name != item.item_name:
			continue
	
	return false
func subtract_item(i:int) -> items:
	
	if not inventory[i].item:
		return null
	
	inventory[i].count-=1
	var temp=inventory[i].item
	if inventory[i].count==0:
		
		inventory[i].item=null
		
		return temp 
	elif inventory[i].count>0:
		return temp.duplicate()
	else:
		assert(false,"count of inventory item was negative")
		return null
	
func update_textures():
	for i in range(rows*columns):
		if inventory[i].item != null:
			grid.get_child(i).fill(inventory[i].item.inventory_texture,inventory[i].count)
		else:
			grid.get_child(i).fill(null,0)
	if extra.item:
		$cursor.texture=extra.item.inventory_texture
	else:
		$cursor.texture=null
			
func slot_clicked(index:int):
	emit_signal("slot_selected",inventory[index].item,inventory[index].count)
	if frozen: return
	if extra.item and inventory[index].item and inventory[index].item.item_name == extra.item.item_name and extra.item.stackable:
		inventory[index].count+=extra.count
		extra.count=0
		extra.item.queue_free()
		extra.item=null
		update_textures()
		return
		
	var temp=extra.item
	var num=extra.count
	
	extra.item=inventory[index].item
	extra.count=inventory[index].count
	inventory[index].item=temp
	inventory[index].count=num
	
	update_textures()
	
	
func clear():
	for i in inventory:
		if i and i.item:
			i.item.queue_free()
		i.item=null
		i.count=0
	update_textures()
func getFirstBowIndexInHotbar() -> int:
	for i in range(8):
		if inventory[i] and inventory[i].item and inventory[i].item is Bow:
			return i
	return -1
func getFirstArrowIndexInInventory() -> int:
	for i in range(len(inventory)):
		if inventory[i].item and inventory[i].item is Arrow:
			return i
	return -1
func isAddable(item_to_be_added:items) -> bool:
	for i in inventory:
		if i.item == null or i.item.item_name==item_to_be_added.item_name and i.item.stackable:
			return true
	return false
