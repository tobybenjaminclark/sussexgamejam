extends Node3D

@export var shooting_speed : float = 2.0  # Time delay between shots
@export var bullet_speed : float = 10.0  # Speed of the bullet
var detection_range : float = 10.0  # Range within which the tower can shoot
@export var bullet_scene : PackedScene  # Bullet scene (create a bullet as a separate scene)
@export var gun_sound : AudioStream  # Gunshot sound effect

var closest_enemy : Node3D  # Reference to the closest enemy
var time_since_last_shot : float = 0.0
var audio_player : AudioStreamPlayer3D  # Audio player for the gunshot sound

func _ready():
	# Add the node to the "Enemy" group to detect them
	add_to_group("Enemy")
	audio_player = get_node_or_null("AudioStreamPlayer3D")
	if gun_sound and audio_player:
		audio_player.stream = gun_sound

func _process(delta):
	# Get the closest enemy in range
	closest_enemy = get_closest_enemy()
	
	if closest_enemy:
		# Calculate the direction and distance to the closest enemy
		var direction_to_enemy = closest_enemy.global_transform.origin - global_transform.origin
		
		var distance_to_enemy = direction_to_enemy.length()
		print("distance to enemy: ", distance_to_enemy, "detection range: ", detection_range)
		

		# Check if the enemy is within the detection range
		if distance_to_enemy <= detection_range:
			# Rotate to face the enemy
			look_at(closest_enemy.global_transform.origin, Vector3.UP)

			# Handle shooting cooldown and shoot if ready
			time_since_last_shot += delta
			if time_since_last_shot >= shooting_speed:
				shoot_bullet(closest_enemy)
				time_since_last_shot = 0.0


func get_closest_enemy() -> Node3D:
	var closest_enemy : Node3D = null
	var closest_distance : float = detection_range  # Limit checks to within detection range

	# Loop through all nodes in the "enemy" group to find the closest one
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy.has_method("stop_moving"):  # Ensure the node has the required method
			var distance = global_transform.origin.distance_to(enemy.global_transform.origin)
			if distance < closest_distance:
				closest_enemy = enemy
				closest_distance = distance
	return closest_enemy

func shoot_bullet(enemy: Node3D):
	# Ensure the enemy is still within detection range before shooting
	if enemy:
		var direction_to_enemy = enemy.global_transform.origin - global_transform.origin
		var distance_to_enemy = direction_to_enemy.length()
		if distance_to_enemy <= detection_range:
			# Instantiate the bullet
			var bullet = bullet_scene.instantiate()
			var muzzle_node = get_node_or_null("MuzzleNode")
			if muzzle_node:
				bullet.global_transform.origin = muzzle_node.global_transform.origin
			else:
				bullet.global_transform.origin = global_transform.origin

			# Set bullet direction and velocity
			bullet.look_at(enemy.global_transform.origin, Vector3.UP)
			var direction = (enemy.global_transform.origin - bullet.global_transform.origin).normalized()
			var velocity = direction * bullet_speed
			if bullet is RigidBody3D:
				bullet.linear_velocity = velocity

			# Add the bullet to the current scene
			get_tree().current_scene.add_child(bullet)

			# Handle muzzle flash particles
			if muzzle_node:
				var muzzle_particles = muzzle_node.get_node_or_null("GPUParticles3D")
				if muzzle_particles:
					muzzle_particles.emitting = true
					var timer = Timer.new()
					timer.wait_time = 0.1
					timer.one_shot = true
					timer.timeout.connect(_stop_emitting)
					muzzle_node.add_child(timer)
					timer.start()

			# Play gunshot sound
			if audio_player:
				audio_player.play()


# This method stops the emission of muzzle particles after a short delay
func _stop_emitting():
	var muzzle_particles = get_node_or_null("MuzzleNode/GPUParticles3D")
	if muzzle_particles:
		muzzle_particles.emitting = false
