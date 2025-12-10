
extends Control
class_name selection_wheel
signal selected(index:int)
@export var inventory:Inventory=null
@export var trigger_action:String="ui_select"
@export var items_count:int=1
@export_range(0.0, 1.0,0.1) var offset_percentage:float
@export var radius:int
@export var inner_circle_color:Color
@export var inner_circle_width:int
@export var circle_color:Color
@export var line_color:Color
@export var line_width:int
@export_range(0.0, 1.0,0.1) var transparency:float
@export var AA:bool=true
@export var image_scale:float=1
@export var select_color:Color
var pictures:Array=[]
var step_angle:float

var angles=[]
var temp
var select:int=0
func _ready() -> void:
	
	visibility_changed.connect(visibilty_changed_reaction)
	step_angle=2*PI/items_count
	
	for j in range(items_count):
		var icon=TextureRect.new()
		var lab=Label.new()
		icon.position=(0.5+offset_percentage/2.0)*radius*Vector2(sin(step_angle*(j+0.5)),-cos(step_angle*(j+0.5)))
		add_child(icon)
		icon.add_child(lab)
		lab.position=Vector2(100,100)
		lab.scale=Vector2(3,3)
		pictures.append(icon)
		icon.pivot_offset=Vector2(-64,-64)
		icon.scale=Vector2(image_scale,image_scale)/2.0
	assign_pictures()
		
		
	
	
func visibilty_changed_reaction():
	if visible:
		assign_pictures()
	else:
		emit_signal("selected",select)
	
func _process(delta: float) -> void:
	if visible:
		queue_redraw()
func _draw() -> void:
	step_angle=2*PI/items_count
	
	
	for i in range(items_count):
		var sp:Vector2=radius*Vector2(sin(step_angle*i),-cos(step_angle*i))
		draw_line(sp,sp*offset_percentage,line_color,line_width,AA)
		
	var alpha_color=circle_color
	alpha_color.a=transparency
	draw_circle(Vector2(0,0),radius,alpha_color,true,-1,AA)
	draw_circle(Vector2(0,0),radius*offset_percentage,inner_circle_color,false,inner_circle_width,AA)
	
	temp=fmod(angle_to_mouse()+TAU,TAU)
	select=int(temp/step_angle)
	temp=select*step_angle-PI/2
	draw_arc(Vector2.ZERO,radius,temp,temp+step_angle,36,select_color,line_width*2,AA)
	


func angle_to_mouse() -> float:
	return PI+Vector2(0,1).angle_to(get_local_mouse_position())
func assign_pictures():
	if not inventory:
		return
	for i in range(len(pictures)):
		if inventory.getItemAt(i):
			pictures[i].texture=inventory.getItemAt(i).inventory_texture
			pictures[i].get_child(0).text=str(inventory.inventory[i].count)
		else:
			pictures[i].texture=null
			pictures[i].get_child(0).text=""
				
