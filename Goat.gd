extends KinematicBody

export var acceleration = 4
export var speed = 99
export var gravity = 0.98

var space_state
var target
var velocity = Vector3()

var goat = load("res://Goat.tscn")
onready var goatinator = get_tree().get_root().find_node("Goatinator", true, false)

func _ready() -> void:
	Events.connect("spawn_goat", self, "_on_goat_spawn")
	space_state = get_world().direct_space_state
	
func _process(delta: float) -> void:
	if target:
		var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		if result.collider.is_in_group("Player"):
			look_at(target.global_transform.origin, Vector3.UP)
			move_to_target(delta)
		else:
			pass
			
func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		target = body
		print(body.name + " entered")

func _on_Area_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		target = null
		print(body.name + " exited")
	
func _on_goat_spawn(goat_name) -> void:
	var horns = load("res://Goat_Parts/red_horns.tres")
	var new_goat = goat.instance()
	var new_horns = new_goat.get_node("Horns")
	var material = horns.material
	material.albedo_color = horns.color
	new_horns.set_surface_material(0, material)
	new_goat.transform.origin = goatinator.transform.origin
	get_node("/root/main").add_child(new_goat)

# func _on_update_horns(part_name):
#	var part_data = load("res://Goat_Parts/" + part_name + ".tres")
#	var part = get_node(".")
#	var material = part_data.material
#	var mesh = part_data.mesh
#	material.albedo_color = part_data.color
#	part.set_surface_material(0, material)
	
func move_to_target(delta):
	var direction = (target.transform.origin - transform.origin).normalized()
	velocity.y -= gravity
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
