extends Control

func _ready() -> void:
	null
	
func pause():
	get_tree().set_deferred("paused", true)
	

func resume():
	get_tree().set_deferred("paused", false)
