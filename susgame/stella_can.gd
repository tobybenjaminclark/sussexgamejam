
# Speed of rotation in degrees per second
export var rotation_speed: float = 90.0

func _process(delta: float):
	# Rotate around the Y-axis (vertical axis)
	rotate_y(rotation_speed * delta)
