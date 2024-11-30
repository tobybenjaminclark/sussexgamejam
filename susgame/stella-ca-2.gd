extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Store the object's original position
	original_position = global_transform.origin
	
	
@export var bobbing_speed: float = 2.0  # Speed of the bobbing motion
@export var bobbing_height: float = 0.5  # Maximum height of the bobbing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	var rotation_speed: float = 0.02
	rotate_y(rotation_speed)
	var offset = sin(Time.get_ticks_msec() / 1000.0 * bobbing_speed) * bobbing_height
	global_transform.origin.y = original_position.y + offset



var original_position: Vector3
