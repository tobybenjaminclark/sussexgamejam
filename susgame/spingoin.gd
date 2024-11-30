extends Node3D

@export var spin_speed: Vector3 = Vector3(0, 60.0, 0)  # Speed of rotation (degrees per second for each axis)

func _process(delta: float) -> void:
	# Convert the spin speed to radians per second and apply to the rotation
	rotation_degrees += spin_speed * delta
