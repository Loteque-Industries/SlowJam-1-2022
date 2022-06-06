extends SpringArm

export var mouse_sensitivity := 0.05

func _ready() -> void:
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event: InputEvent) -> void:
	var right_pad_axis = Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3))
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
	
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
	
	if event is InputEventJoypadMotion:
		rotate_y(Input.get_action_strength("camera_left") * mouse_sensitivity)
		rotate_y(Input.get_action_strength("camera_right") * mouse_sensitivity * -1)
