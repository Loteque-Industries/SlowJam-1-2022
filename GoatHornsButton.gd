extends Button

export (String) var part_name

func _pressed() -> void:
	Events.emit_signal("update_horns", part_name)
