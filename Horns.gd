extends MeshInstance

func _ready() -> void:
	var part_data = load("res://Goat_Parts/blue_horns.tres")
	update_part_display(part_data)

func update_part_display(part_data):
	var part = get_node(".")
	var material = part_data.material
	var mesh = part_data.mesh
	material.albedo_color = part_data.color
	part.set_surface_material(0, material)
