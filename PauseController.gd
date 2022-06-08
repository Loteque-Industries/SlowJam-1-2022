extends Node

export(bool) var can_toggle_pause: bool = true
var main_menu
var continue_menu

func _ready() -> void:
	main_menu = get_tree().get_root().find_node("MainMenu", true, false)
	continue_menu = get_tree().get_root().find_node("ContinueMenu", true, false)
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	main_menu.show()
	pause()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start_menu"):
		if !get_tree().paused:
			pause()
		else:
			resume()

func pause():
	if can_toggle_pause:
		get_tree().set_deferred("paused", true)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if main_menu.visible == true:
			continue_menu.hide()
		else:
			continue_menu.show()
		
func resume():
	if can_toggle_pause:
		get_tree().set_deferred("paused", false)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		continue_menu.hide()
		main_menu.hide()
			
func quit_to_menu():
	pass
