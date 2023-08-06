extends TextureButton


func _on_pressed() -> void:
	if not $"../Pause".is_paused:
		$"../Pause".is_paused = true
	else:
		if $"../Pause/Help".visible:
			$"../Pause/Help".hide()
		else:
			$"../Pause".is_paused = false

