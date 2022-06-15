extends Spatial

export (SpatialMaterial) var horn_material

onready var factory = preload("res://BaseGoat.tscn").instance()
onready var goatinator = get_tree().get_root().find_node("Goatinator", true, false)

func _ready() -> void:
	Events.connect("update_horns", self, "_on_update_horns")
	Events.connect("spawn_goat", self, "_on_goat_spawn")

func _on_goat_spawn(goat_name) -> void:
	var new_goat = factory.generate_goat(0)
	var horns = new_goat.get_child(2)
	#var head = factory.generate_goat(3)
	#var body = factory.generate_goat(4)
	#var feet = factory.generate_goat(5)
	#var tail = factory.generate_tail(6)
	var material = SpatialMaterial.new()
	material.albedo_color = horn_material.albedo_color
	horns.set_surface_material(0, material)
	new_goat.transform.origin = goatinator.transform.origin
	add_child(new_goat)

func _on_update_horns(part_name):
	var part_data = load("res://Goat_Parts/" + part_name + ".tres")
	var part = get_node("UserInterface/GoatinatorMenu/ViewportContainer/Viewport/BaseGoat/Goat/Horns")
	var material = part_data.material
	material.albedo_color = part_data.color
	horn_material = material
	part.set_surface_material(0, material)
