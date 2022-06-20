extends KinematicBody

export var acceleration = 4
export var speed = 99
export var gravity = 1.0

var space_state
var target
var proximity
var proximity_target
var velocity = Vector3()
var direction = Vector3()

func _ready() -> void:
	space_state = get_world().direct_space_state
	
func _process(delta: float) -> void:
	if target:
		var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		if result.collider.is_in_group("Player"):
			look_at(target.global_transform.origin, Vector3.UP)
			move_to_target(delta)
			get_node("AnimatedGoat/AnimationPlayer").play("Run")
		
	elif proximity_target:
		var proximity = space_state.intersect_ray(global_transform.origin, proximity_target.global_transform.origin)
		if proximity.collider.is_in_group("Player"):
			look_at(proximity_target.global_transform.origin, Vector3.UP)
			get_node("AnimatedGoat/AnimationPlayer").play("Alert")
	
	else:
		if is_on_floor():
			get_node("AnimatedGoat/AnimationPlayer").play("Idle")


func move_to_target(delta):
	var direction = (target.transform.origin - transform.origin).normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	move_and_slide(velocity, Vector3.UP, true, 4, 1.22173)

func _on_Aggro_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		target = body


func _on_Aggro_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		target = null


func _on_Proximity_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		proximity_target = body


func _on_Proximity_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		proximity_target = null
