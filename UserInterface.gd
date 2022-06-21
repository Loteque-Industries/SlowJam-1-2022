extends Control

var main_menu
var pause_menu
var goatinator_menu
var i := 0

func _ready() -> void:
	main_menu = get_tree().get_root().find_node("MainMenu", true, false)
	pause_menu = get_tree().get_root().find_node("PauseMenu", true, false)
	goatinator_menu = get_tree().get_root().find_node("GoatinatorMenu", true, false)
	
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

func _on_ShutdownGoatinatorButton_pressed() -> void:
	if goatinator_menu.visible == true:
		goatinator_menu.hide()
	if get_tree().paused and main_menu.visible == true:
		get_tree().set_deferred("paused", true)
		goatinator_menu.hide()
	else:
		get_tree().set_deferred("paused", false)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	get_node("AudioStreamPlayer").play()
	#signal to spawn the goat on exit
	Events.emit_signal("spawn_goat", "goat" + str(i))
	i = i + 1
