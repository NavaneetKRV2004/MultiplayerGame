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
	
	Rend_method_option.select(s.Rend_Method)
	fps_option.select(fps_option.get_item_index(s.fps))
	fov_slider.value=s.FOV
	fov_label.text=str(s.FOV)
	MS_slider.value=s.MS
	ms_label.text=str(s.MS)
	JS_slider.value=s.JS
	js_label.text=str(s.JS)
	$"Panel2/TabContainer/Video/Panel/VBoxContainer/crosshair size".value=s.cross_hair_size
	$"Panel2/TabContainer/Video/Panel/VBoxContainer/crosshair size/Label".text=str(s.cross_hair_size)
	$Panel2/TabContainer/Video/Panel/VBoxContainer/SpinBox.value=s.cross_hair_type
func open_settings_file():
	OS.shell_open(ProjectSettings.globalize_path(s.saveData))


func _on_rmethod_item_selected(index):
	s.Rend_Method=index


func _on_fps_item_selected(index):
	s.fps=fps_option.get_item_id(index)


func _on_fov_drag_ended(_value_changed):
	s.FOV=fov_slider.value
	fov_label.text="%d"%fov_slider.value
	


func _on_ms_drag_ended(value_changed):
	s.MS=MS_slider.value
	ms_label.text="%d"%MS_slider.value
	


func _on_js_drag_ended(value_changed):
	s.JS=JS_slider.value
	js_label.text="%d"%JS_slider.value


func hide_self() -> void:
	hide()
	s.save_()


func _on_crosshair_size_value_changed(value_changed) -> void:
	s.cross_hair_size=value_changed
	$"Panel2/TabContainer/Video/Panel/VBoxContainer/crosshair size/Label".text=str(value_changed)


func _on_spin_box_value_changed(value: float) -> void:
	s.cross_hair_type=int(value)
