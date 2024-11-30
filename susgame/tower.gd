extends Node3D



@export var shooting_speed : float = 2.0  # Time delay between shots
@export var bullet_speed : float = 10.0  # Speed of the bullet
@export var detection_range : float = 20.0  # Range within which the tower can shoot
@export var bullet_scene : PackedScene  # Bullet scene (create a bullet as a separate scene)



var player : Node3D  # Reference to the player
var time_since_last_shot : float = 0.0


func _ready():
	player = get_node_or_null("/root/Node3D/Player")



func _process(delta):
	if player:
		# Rotate the tower to face the player
		look_at(player.global_transform.origin, Vector3.UP)
		var direction_to_player = player.global_transform.origin - global_transform.origin
		var distance_to_player = direction_to_player.length()
		if distance_to_player <= detection_range:
			time_since_last_shot += delta
			if time_since_last_shot >= shooting_speed:
				shoot_bullet()
				time_since_last_shot = 0.0



func shoot_bullet():
	var bullet = bullet_scene.instantiate()

	# Create a Node3D at the end of the barrel (or use an existing one)
	var muzzle_node = get_node_or_null("MuzzleNode")

	# Optionally, add the muzzle node to the scene for debugging or visual purposes
	get_tree().current_scene.add_child(muzzle_node)

	# Position the bullet at the muzzle position
	bullet.global_transform.origin = muzzle_node.global_transform.origin

	# Make bullet face the player
	bullet.look_at(player.global_transform.origin, Vector3.UP)

	# Calculate direction towards the player
	var direction = (player.global_transform.origin - bullet.global_transform.origin).normalized()

	# Set the velocity of the bullet (direction * speed)
	var velocity = direction * bullet_speed

	# Set velocity for a RigidBody3D bullet
	if bullet is RigidBody3D:
		bullet.linear_velocity = velocity

	# Add the bullet to the scene
	get_tree().current_scene.add_child(bullet)

	# Emit particles from the muzzle node's GPUParticles3D
	var muzzle_particles = muzzle_node.get_node_or_null("GPUParticles3D")
	if muzzle_particles:
		# Start the particle emission
		muzzle_particles.emitting = true
		
		# Optionally, you can stop emitting after a short time (e.g., 0.1 seconds)
		var timer = Timer.new()
		timer.wait_time = 0.1
		timer.one_shot = true
		timer.timeout.connect(_stop_emitting)
		muzzle_node.add_child(timer)
		timer.start()

# The function _stop_emitting is created to stop the particles
func _stop_emitting():
	var muzzle_particles = get_node_or_null("MuzzleNode/GPUParticles3D")
	if muzzle_particles:
		muzzle_particles.emitting = false
