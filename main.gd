extends Spatial

export (SpatialMaterial) var select_material

var goat_parts = {"horns": "small_horns", "ears": "dish_ears", "body": "", "tail": "small_tail"}

#load goat body textures
onready var TexBaseColor = preload("res://Textures/T_GoatBase_BaseColor.png")
onready var TexNormal = preload("res://Textures/T_GoatBase_Normal.png")
onready var TexRoughness = preload("res://Textures/T_GoatBase_Roughness.png")
onready var TexHeight = preload("res://Textures/T_GoatBase_Height.png")

#load goat parts textures
onready var TexPartsBaseColor = preload("res://Textures/T_GoatParts_BaseColor.png")
onready var TexPartsNormal = preload("res://Textures/T_GoatParts_Normal.png")
onready var TexPartsRoughness = preload("res://Textures/T_GoatParts_Roughness.png")

#load goat parts buttons data
onready var brown_goat_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/BrownGoatButton")
onready var yellow_goat_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/YellowGoatButton")
onready var green_goat_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/GreenGoatButton")
onready var red_goat_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/RedGoatButton")
onready var blue_goat_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/BlueGoatButton")
onready var spiral_horns_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/SpiralHornsButton")
onready var long_horns_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/LongHornsButton")
onready var small_horns_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/SmallHornsButton")
onready var jacobs_horns_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/JacobsHornsButton")
onready var fluffy_tail_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/FluffyTailButton")
onready var devil_tail_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/DevilTailButton")
onready var double_tail_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/DoubleTailButton")
onready var small_tail_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/SmallTailButton")
onready var dagoat_ears_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/DagoatEarsButton")
onready var rabbit_ears_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/RabbitEarsButton")
onready var dish_ears_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/DishEarsButton")
onready var floppy_ears_button = get_node("UserInterface/GoatinatorMenu/MarginContainer/ScrollContainer/Control/VBoxContainer/FloppyEarsButton")

#load goat factory data
onready var factory = preload("res://BaseGoat.tscn").instance()
onready var goatinator = get_tree().get_root().find_node("Goatinator", true, false)

func _ready() -> void:
	Events.connect("update_horns", self, "_on_update_horns")
	Events.connect("update_ears", self, "_on_update_ears")
	Events.connect("update_body", self, "_on_update_body")
	Events.connect("update_tail", self, "_on_update_tail")
	Events.connect("spawn_goat", self, "_on_goat_spawn")
	
	
func _on_goat_spawn(goat_name) -> void:
	var new_goat = factory.generate_goat(0)
	var body_target = new_goat.get_child(4)
	var armature = body_target.get_child(0)
	var skeleton = armature.get_child(0)
	var horns = new_goat.get_child(2)
	var ears = new_goat.get_child(3)
	var body = skeleton.get_child(0)
	var tail = new_goat.get_child(5)
	var material = SpatialMaterial.new()
	var parts_material = SpatialMaterial.new()
	
	#apply default parts material
	parts_material.albedo_color = select_material.albedo_color
	parts_material.albedo_texture = TexBaseColor
	parts_material.normal_enabled = true
	parts_material.normal_texture = TexPartsNormal
	parts_material.roughness_texture = TexPartsRoughness
	
	#apply default goat body material
	material.albedo_color = select_material.albedo_color
	material.albedo_texture = TexBaseColor
	material.normal_enabled = true
	material.normal_texture = TexNormal
	material.roughness_texture = TexRoughness
	body.set_surface_material(0, material)
	
	#apply goat ear material 
	var new_ears = load("res://Goat_Parts/" + goat_parts["horns"] + ".tres")
	var ear_mesh = MeshInstance.new()
	var ear_material = SpatialMaterial.new()
	ear_material.albedo_color = new_ears.color
	ears.set_surface_material(0, ear_material)
	ears.set_mesh(new_ears.mesh)
	print(goat_parts["ears"])
	
	#apply goat horn material 
	var new_horns = load("res://Goat_Parts/" + goat_parts["horns"] + ".tres")
	var horn_mesh = MeshInstance.new()
	var horn_material = SpatialMaterial.new()
	horn_material.albedo_color = new_horns.color
	horns.set_surface_material(0, horn_material)
	horns.set_mesh(new_horns.mesh)
	print(goat_parts["horns"])
	
	#apply goat tail material
	var new_tail = load("res://Goat_Parts/" + goat_parts["tail"] + ".tres")
	var tail_mesh = MeshInstance.new()
	var tail_material = SpatialMaterial.new()
	tail_material.albedo_color = new_tail.color
	tail.set_surface_material(0, tail_material)
	tail.set_mesh(new_tail.mesh)
	print(goat_parts["tail"])
	
	#spawn goat at the goatinator
	new_goat.transform.origin = goatinator.transform.origin
	add_child(new_goat)

func _on_update_horns(part_name):
	var part_data = load("res://Goat_Parts/" + part_name + ".tres")
	var part = get_node("UserInterface/GoatinatorMenu/ViewportContainer/Viewport/BaseGoat/Goat/Horns")
	var material = part_data.material
	var mesh = part_data.mesh
	material.albedo_color = part_data.color
	part.set_surface_material(0, material)
	part.set_mesh(mesh)
	select_material = material
	goat_parts["horns"] = part_name
	unlock_part_button()

func _on_update_ears(part_name):
	var part_data = load("res://Goat_Parts/" + part_name + ".tres")
	var part = get_node("UserInterface/GoatinatorMenu/ViewportContainer/Viewport/BaseGoat/Goat/Ears")
	var material = part_data.material
	var mesh = part_data.mesh
	material.albedo_color = part_data.color
	part.set_surface_material(0, material)
	part.set_mesh(mesh)
	select_material = material
	goat_parts["ears"] = part_name
	unlock_part_button()

func _on_update_body(part_name):
	var part_data = load("res://Goat_Parts/" + part_name + ".tres")
	var part = get_node("UserInterface/GoatinatorMenu/ViewportContainer/Viewport/BaseGoat/Goat/Body/Armature/Skeleton/GoatBase_low_Mesh001")
	var material = part_data.material
	material.albedo_color = part_data.color
	part.set_surface_material(0, material)
	select_material = material
	goat_parts["body"] = part_name
	unlock_part_button()
	
func _on_update_tail(part_name):
	var part_data = load("res://Goat_Parts/" + part_name + ".tres")
	var part = get_node("UserInterface/GoatinatorMenu/ViewportContainer/Viewport/BaseGoat/Goat/Tail")
	var material = part_data.material
	var mesh = part_data.mesh
	material.albedo_color = part_data.color
	part.set_surface_material(0, material)
	part.set_mesh(mesh)
	select_material = material
	goat_parts["tail"] = part_name
	unlock_part_button()
	
func unlock_part_button():
#	
	if goat_parts["horns"] == "small_horns" and goat_parts["tail"] == "small_tail" and goat_parts["ears"] == "dish_ears" and goat_parts["body"] == "yellow_goat":
		if !brown_goat_button.is_visible():
			Events.emit_signal("unlock_part", "Brown Goat")
			brown_goat_button.show() 
#
	if goat_parts["body"] == "green_goat" and goat_parts["tail"] == "fluffy_tail" and goat_parts["ears"] == "rabbit_ears":
		if !yellow_goat_button.is_visible():
			Events.emit_signal("unlock_part", "Yellow Goat")
			yellow_goat_button.show() 
#starting button so it shows by default
	if goat_parts["body"] == "green_goat":
		if !green_goat_button.is_visible():
			Events.emit_signal("unlock_part", "Green Goat")
			green_goat_button.show()
#
	if goat_parts["ears"] == "rabbit_ears":
		if !blue_goat_button.is_visible():
			Events.emit_signal("unlock_part", "Blue Goat")
			blue_goat_button.show()
#
	if goat_parts["tail"] == "devil_tail" and goat_parts["horns"] == "long_horns":
		if !red_goat_button.is_visible():
			Events.emit_signal("unlock_part", "Red Goat")
			red_goat_button.show()
#
	if goat_parts["body"] == "red_goat" and goat_parts["horns"] == "jacobs_horns" and goat_parts["tail"] == "devil_tail":
		if !spiral_horns_button.is_visible():
			Events.emit_signal("unlock_part", "Spiral Horns")
			spiral_horns_button.show()
#
	if goat_parts["body"] == "blue_goat" and goat_parts["ears"] == "rabbit_ears":
		if !long_horns_button.is_visible():
			Events.emit_signal("unlock_part", "Long Horns")
			long_horns_button.show()
#
	if goat_parts["body"] == "blue_goat" and goat_parts["horns"] == "spiral_horns" and goat_parts["tail"] == "double_tail":
		if !small_horns_button.is_visible():
			Events.emit_signal("unlock_part", "Small Horns")
			small_horns_button.show()
#
	if goat_parts["body"] == "red_goat" and goat_parts["tail"] == "devil_tail" and goat_parts["ears"] == "rabbit_ears":
		if !jacobs_horns_button.is_visible():
			Events.emit_signal("unlock_part", "Jacob's Horns")
			jacobs_horns_button.show()
#
	if goat_parts["body"] == "green_goat" and goat_parts["ears"] == "rabbit_ears" and goat_parts["horns"] == "long_horns":
		if !fluffy_tail_button.is_visible():
			Events.emit_signal("unlock_part", "Fluffy Tail")
			fluffy_tail_button.show()
#
	if goat_parts["body"] == "blue_goat" and goat_parts["tail"] == "fluffy_tail":
		if !devil_tail_button.is_visible():
			Events.emit_signal("unlock_part", "Devil Tail")
			devil_tail_button.show()
#
	if goat_parts["tail"] == "fluffy_tail" and goat_parts["ears"] == "rabbit_ears":
		if !double_tail_button.is_visible():
			Events.emit_signal("unlock_part", "Double Tail")
			double_tail_button.show()
#
	if goat_parts["body"] == "yellow_goat" and goat_parts["horns"] == "spiral_horns":
		if !small_tail_button.is_visible():
			Events.emit_signal("unlock_part", "Small Tail")
			small_tail_button.show()
#
	if goat_parts["body"] == "yellow_goat" and goat_parts["tail"] == "double_tail":
		if !dagoat_ears_button.is_visible():
			Events.emit_signal("unlock_part", "Da Goat Ears")
			dagoat_ears_button.show()
#
	if goat_parts["body"] == "green_goat":
		if !rabbit_ears_button.is_visible():
			Events.emit_signal("unlock_part", "Rabbit Ears")
			rabbit_ears_button.show()
#
	if goat_parts["body"] == "green_goat" and goat_parts["horns"] == "spiral_horns":
		if !dish_ears_button.is_visible():
			Events.emit_signal("unlock_part", "Dish Ears")
			dish_ears_button.show()
#
	if goat_parts["body"] == "blue_goat" and goat_parts["ears"] == "dagoat_ears":
		if !floppy_ears_button.is_visible():
			Events.emit_signal("unlock_part", "Floppy Ears")
			floppy_ears_button.show()
