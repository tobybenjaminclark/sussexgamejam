extends Node3D

var ray_origin = Vector3()
var ray_target = Vector3()

func _physics_process(delta):
	# Get the mouse position on the viewport
	var mouse_position = get_viewport().get_mouse_position()

	# Compute the ray origin and ray target from the camera
	ray_origin = $Camera3D.project_ray_origin(mouse_position)
	ray_target = ray_origin + $Camera3D.project_ray_normal(mouse_position) * 2000

	# Get the direct space state for physics queries
	var space_state = get_world_3d().direct_space_state

	# Create and configure the ray query parameters
	var params = PhysicsRayQueryParameters3D.new()
	params.from = ray_origin
	params.to = ray_target

	# Perform the ray intersection query
	var intersection = space_state.intersect_ray(params)
	
	# Check if the intersection has any result
	if intersection.has("position"):
		var pos = intersection.position
		var look_at_me = Vector3(pos.x, $Santa.global_transform.origin.y, pos.z)
		$Santa.look_at(look_at_me, Vector3.UP)
