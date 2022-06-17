extends PanelContainer


func _ready() -> void:
	Events.connect("unlock_part", self, "_on_unlock_part")
	hide()

func _on_unlock_part(part_name) -> void:
	print(part_name)
	show()
	get_child(0).set_text("You Unlocked " + part_name + "!")
	get_child(1).queue("popup_shake")
