extends KinematicBody

export var speed = 10
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 30
export var mouse_sensitivity = 0.3

onready var head = $Head
onready var camera = $Head/Camera

var target
var space_state
var velocity = Vector3()
var camera_x_rotation = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -92 and camera_x_rotation + x_delta < 89:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta

func _ready() -> void:
	space_state = get_world().direct_space_state
		
func _physics_process(delta: float) -> void:
	var direction = Vector3()
	var head_basis = head.get_global_transform().basis
	
	if Input.is_action_pressed("forward"):
		direction -= head_basis.z
	elif Input.is_action_pressed("back"):
		direction += head_basis.z
	
	if Input.is_action_pressed("left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("right"):
		direction += head_basis.x
		
	if target:
		var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		if result.collider.is_in_group("Goat"):
			direction = target.global_transform.origin
			direction = direction.normalized()
			velocity.y -= gravity
			velocity = velocity.linear_interpolate(direction * speed * 10, 10 * acceleration * delta)
			
	direction = direction.normalized()
	velocity.y -= gravity
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_power
	
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, 1.22173)
	#Hack to fix a bug with move_and_slide in godot.
	#discussion/demo: https://www.reddit.com/r/godot/comments/hc4lur/how_to_move_and_stop_correctly_on_slopes_using
	#see funcion "slope()"
	var slides = get_slide_count()
	if(slides):
		slope(slides)
	
func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group("Goat"):
		target = body
		print(body.name + " entered")

func _on_Area_body_exited(body: Node) -> void:
	if body.is_in_group("Goat"):
		target = null
		print(body.name + " exited")

#Hack to fix a bug with move_and_slide in godot.
#discussion/demo: https://www.reddit.com/r/godot/comments/hc4lur/how_to_move_and_stop_correctly_on_slopes_using
func slope(slides : int):
	for i in slides:
		var touched = get_slide_collision(i)
		if is_on_floor() && touched.normal.y < 1.0 && (velocity.x != 0.0 || velocity.z != 0.0):
			velocity.y = touched.normal.y
