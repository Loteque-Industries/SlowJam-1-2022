extends Control

var main_menu
var pause_menu
var goatinator_menu

onready var goatinator = get_tree().get_root().find_node("Goatinator", true, false)
var goat = preload("res://Goat.tscn")

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
	
	#spawn the goat on exit
	var newGoat = goat.instance()
	newGoat.transform.origin = goatinator.transform.origin
	get_node("/root/main").add_child(newGoat)
	
