extends MeshInstance

func _ready() -> void:
	Events.connect("update_horns", self, "_on_update_horns")
	

func _on_update_horns(part_name):
	print("pressed" + " red horns button")
	var part_data = load("res://Goat_Parts/" + part_name + ".tres")
	var part = get_node(".")
	var material = part_data.material
	material.albedo_color = part_data.color
	part.set_surface_material(0, material)
