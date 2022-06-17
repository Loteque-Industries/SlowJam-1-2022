extends Spatial

export (SpatialMaterial) var select_material

var goat_parts = {"horns": "", "ears": "red_ears", "body": "", "tail": ""}

onready var TexBaseColor = preload("res://Textures/T_GoatBase_BaseColor.png")
onready var TexNormal = preload("res://Textures/T_GoatBase_Normal.png")
onready var TexRoughness = preload("res://Textures/T_GoatBase_Roughness.png")
onready var TexHeight = preload("res://Textures/T_GoatBase_Height.png")

onready var yellow_goat_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/Button")
onready var green_goat_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/Button2")
onready var factory = preload("res://BaseGoat.tscn").instance()
onready var goatinator = get_tree().get_root().find_node("Goatinator", true, false)

func _ready() -> void:
	Events.connect("update_horns", self, "_on_update_horns")
	Events.connect("update_body", self, "_on_update_body")
	Events.connect("spawn_goat", self, "_on_goat_spawn")

func _on_goat_spawn(goat_name) -> void:
	var new_goat = factory.generate_goat(0)
	#var ears = new_goat.get_child(2)
	var horns = new_goat.get_child(3)
	var body = new_goat.get_child(4)
	#var tail = new_goat.generate_tail(5)
	var material = SpatialMaterial.new()
	
	#apply goat body material
	material.albedo_color = select_material.albedo_color
	material.albedo_texture = TexBaseColor
	material.normal_enabled = true
	material.normal_texture = TexNormal
	material.roughness_texture = TexRoughness
	body.set_surface_material(0, material)
	new_goat.transform.origin = goatinator.transform.origin
	
	#apply goat horn material 
	material = SpatialMaterial.new()
	material.albedo_color = select_material.albedo_color
	horns.set_surface_material(0, material)
	new_goat.transform.origin = goatinator.transform.origin
	
	add_child(new_goat)

func _on_update_horns(part_name):
	var part_data = load("res://Goat_Parts/" + part_name + ".tres")
	var part = get_node("UserInterface/GoatinatorMenu/ViewportContainer/Viewport/BaseGoat/Goat/Horns")
	var material = part_data.material
	material.albedo_color = part_data.color
	part.set_surface_material(0, material)
	select_material = material
	goat_parts["horns"] = part_name
	unlock_part_button()

func _on_update_body(part_name):
	var part_data = load("res://Goat_Parts/" + part_name + ".tres")
	var part = get_node("UserInterface/GoatinatorMenu/ViewportContainer/Viewport/BaseGoat/Goat/Body")
	var material = part_data.material
	material.albedo_color = part_data.color
	part.set_surface_material(0, material)
	select_material = material
	goat_parts["body"] = part_name
	unlock_part_button()
	
func unlock_part_button():
	if goat_parts["body"] == "red_goat" and goat_parts["horns"] == "blue_horns":
		if !yellow_goat_button.is_visible():
			Events.emit_signal("unlock_part", "Yellow Goat")
			yellow_goat_button.show() 
		
	if goat_parts["body"] == "yellow_goat":
		if !green_goat_button.is_visible():
			Events.emit_signal("unlock_part", "Green Goat")
			green_goat_button.show()
