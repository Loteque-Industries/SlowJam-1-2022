extends Spatial

func _ready() -> void:
	pass


func _on_Area_body_entered(body: Node) -> void:
	var trigger = get_node("Area")
	if body.is_in_group("Player"):
		get_node("AnimationPlayer").play("FadeOut")
		get_node("AudioStreamPlayer3D").play()
		yield(get_tree().create_timer(1.1), "timeout")
		get_node(".").remove_child(trigger)
