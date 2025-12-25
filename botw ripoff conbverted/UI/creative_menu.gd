extends ItemList

func _ready() -> void:
	
	for i:String in g.list_of_items:
		var text_link=g.list_of_items[i].texture
		add_item(i,load(text_link) if text_link else null )



func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == 1:
		var temp:items=load(g.list_of_items[get_item_text(index)]["scene"]).instantiate()
		get_parent().add_item(temp,1)
