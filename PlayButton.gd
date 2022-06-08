extends MenuButton

var main_menu
var continue_menu

func _ready() -> void:
	main_menu = get_tree().get_root().find_node("MainMenu", true, false)
	continue_menu = get_tree().get_root().find_node("ContinueMenu", true, false)

func _on_PlayButton_pressed() -> void:
	main_menu.hide()
	get_tree().set_deferred("paused", false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
