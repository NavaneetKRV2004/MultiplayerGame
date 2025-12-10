extends TextureButton
@export var manager:Node
@export_range(0.0,1.0) var image_percentage:float = 0.75
@export var index:int = 0


func _ready() -> void:
	
	_fit_image()


func fill(image:Texture2D=null,count:int=0):
	
		$icon.texture=image
		$Label.text=str(count) if count>1 else ""
		_fit_image()
		
func _fit_image():
	$icon.pivot_offset=$icon.size/2
	$icon.scale=Vector2(1,1)*image_percentage



func _on_button_down() -> void:
	
	manager.slot_clicked(index)
	
	
