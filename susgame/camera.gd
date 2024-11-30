extends Camera3D

@export var target: Node3D  # Drag and drop your target node in the editor
@export var smooth_speed: float = 5.0  # Camera follow speed
@export var camera_offset: Vector3 = Vector3(10, 10, 10)  # Default offset for isometric view

func _ready():
	# Set the camera to orthogonal projection
	projection = PROJECTION_ORTHOGONAL
	size = 10.0  # Adjust this for zoom level
	# Initialize camera position and orientation
	_adjust_camera()

func _process(delta):
	if target:
		_smooth_follow(delta)

# Adjust camera orientation and position
func _adjust_camera():
	rotation_degrees = Vector3(-45, 45, 0)  # Isometric rotation
	global_position = target.global_transform.origin + camera_offset if target else camera_offset
	
func _smooth_follow(delta):
	var desired_position = target.global_transform.origin + camera_offset
	global_transform.origin = global_transform.origin.lerp(desired_position, smooth_speed * delta)
	look_at(target.global_transform.origin, Vector3.UP)
