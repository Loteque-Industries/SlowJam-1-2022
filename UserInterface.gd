extends Control

var main_menu
var pause_menu

func _ready() -> void:
	main_menu = get_tree().get_root().find_node("MainMenu", true, false)
	pause_menu = get_tree().get_root().find_node("PauseMenu", true, false)

func _on_PlayButton_pressed() -> void:
	main_menu.hide()
	get_tree().set_deferred("paused", false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_ContinueButton_pressed() -> void:
	pause_menu.hide()
	get_tree().set_deferred("paused", false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_QuitButton_pressed() -> void:
	pause_menu.hide()
	get_tree().quit()
