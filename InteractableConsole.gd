extends Interactable

onready var goatinator_menu = get_tree().get_root().find_node("GoatinatorMenu", true, false)

func get_interaction_text():
	return "use Goatinator"

func interact():
	get_tree().set_deferred("paused", true)
	goatinator_menu.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
