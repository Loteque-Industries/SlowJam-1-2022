extends KinematicBody

export var acceleration = 4
export var speed = 99
export var gravity = 0.98

var space_state
var target
var velocity = Vector3()

func _ready() -> void:
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
	
func move_to_target(delta):
	var direction = (target.transform.origin - transform.origin).normalized()
	velocity.y -= gravity
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
