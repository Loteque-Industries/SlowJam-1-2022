extends Node

export(bool) var can_toggle_pause: bool = true
var main_menu
var pause_menu
var goatinator_menu

func _ready() -> void:
	main_menu = get_tree().get_root().find_node("MainMenu", true, false)
	pause_menu = get_tree().get_root().find_node("PauseMenu", true, false)
	goatinator_menu = get_tree().get_root().find_node("GoatinatorMenu", true, false)
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	main_menu.show()
	pause()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start_menu"):
		if !get_tree().paused:
			pause()
		else:
			resume()
		
		if goatinator_menu.visible == true:
			goatinator_menu.hide()
			resume()

func pause():
	if can_toggle_pause:
		get_tree().set_deferred("paused", true)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if main_menu.visible == true:
			pause_menu.hide()
		else:
			pause_menu.show()
		
func resume():
	if can_toggle_pause:
		get_tree().set_deferred("paused", false)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		pause_menu.hide()
