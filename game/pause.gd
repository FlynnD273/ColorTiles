extends Control

signal reset
signal pause_changed(pause_state: bool)
signal zoom_changed(new_zoom: float)

var _is_paused: bool
var is_paused: bool:
	get:
		return _is_paused
	set(value):
		if is_paused != value:
			_is_paused = value
			pause_changed.emit(is_paused)
			if is_paused:
				get_tree().paused = true
				show()
			else:
				get_tree().paused = false				
				hide()
				$Help.hide()

func _on_reset_button_pressed() -> void:
	reset.emit()
	is_paused = false
	hide()


func _on_resume_button_pressed() -> void:
	is_paused = false


func _on_camera_zoom_slider_value_changed(value: float) -> void:
	if value == $CameraZoomSlider.min_value:
		zoom_changed.emit(0)
	else:
		zoom_changed.emit(value)
