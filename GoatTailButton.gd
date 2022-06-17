extends Button

export (String) var part_name

func _pressed() -> void:
	Events.emit_signal("update_tail", part_name)
