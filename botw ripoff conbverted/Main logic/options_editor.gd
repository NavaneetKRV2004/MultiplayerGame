extends Control
@export var fov_slider:HSlider
@export var MS_slider:HSlider
@export var JS_slider:HSlider
@export var Rend_method_option:OptionButton
@export var fps_option:OptionButton
@export var fov_label:Label
@export var ms_label:Label
@export var js_label:Label

func _ready():
	
	Rend_method_option.select(s.settings.Rend_Method)
	fps_option.select(fps_option.get_item_index(s.settings.fps))
	fov_slider.value=s.settings.FOV
	fov_label.text=str(s.settings.FOV)
	MS_slider.value=s.settings.MS
	ms_label.text=str(s.settings.MS)
	JS_slider.value=s.settings.JS
	js_label.text=str(s.settings.JS)



func _on_rmethod_item_selected(index):
	s.settings.Rend_Method=index


func _on_fps_item_selected(index):
	s.settings.fps=fps_option.get_item_id(index)


func _on_fov_drag_ended(_value_changed):
	s.settings.FOV=fov_slider.value
	fov_label.text="%d"%fov_slider.value
	


func _on_ms_drag_ended(value_changed):
	s.settings.MS=MS_slider.value
	ms_label.text="%d"%MS_slider.value
	


func _on_js_drag_ended(value_changed):
	s.settings.JS=JS_slider.value
	js_label.text="%d"%JS_slider.value


func hide_self() -> void:
	hide()
	s.save_()
