extends Node3D  # or Node2D for 2D

@export var rotation_speed : float = 1.0  # Rotation speed in degrees per second

# Called every frame
func _process(delta):
	# Rotate around the Y-axis (for 3D objects) or Z-axis (for 2D objects)
	rotate(Vector3(0, 1, 0), rotation_speed * delta)  # 3D rotation around Y-axis
	# For 2D rotation, use this instead:
	# rotate(rotation_speed * delta)  # 2D rotation around Z-axis
