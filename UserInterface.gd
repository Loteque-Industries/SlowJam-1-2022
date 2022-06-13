extends Control

var main_menu
var pause_menu
var goatinator_menu

#goatinator game logic
#will have to be moved out of UI logic eventually
onready var goatinator = get_tree().get_root().find_node("Goatinator", true, false)
var goat = preload("res://Goat.tscn")
var goat_horns
var goat_head
var goat_body
var goat_feet
var goat_tail

#UI Logic 
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
	
	
# Gaotinator Game Logic
# At some point all this logic will need to be moved out of the UI logic.
func _on_RedHornsButton_pressed() -> void:
	var material = SpatialMaterial.new()
	var horns = get_tree().get_root().find_node("Horns", true, false)
	material.albedo_color = Color(1.0, 0.0, 0.0)
	var hornColor = horns.set_surface_material(0, material)
	
