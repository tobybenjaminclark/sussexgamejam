extends RigidBody3D

@export var speed : float = 20.0  # Bullet speed
@export var lifetime : float = 5.0  # Time after which the bullet will be destroyed
var direction : Vector3  # Direction in which the bullet will travel
var target : Node3D  # Reference to the target (enemy)

# Called when the bullet is ready
func _ready():
	set_as_top_level(true)  # Correct method to make the bullet move independently
	add_to_group("Bullet")
	

	# Find the closest enemy in the "enemy" group
	target = get_closest_enemy()
	if target:
		# Calculate direction towards the target (enemy)
		direction = (target.global_transform.origin - global_transform.origin).normalized()

		# Set the bullet's velocity to move towards the target
		linear_velocity = direction * speed
	else:
		print("No enemy found for the bullet!")

	# Set up a timer to destroy the bullet after its lifetime
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_lifetime_end"))
	timer.start()

	# Connect the body_entered signal to handle collision
	connect("body_entered", Callable(self, "_on_Bullet_body_entered"))

# This function is called when the bullet's lifetime ends
func _on_lifetime_end():
	queue_free()  # Free (delete) the bullet from the scene

# Detect collision with enemies or other objects
func _on_Bullet_body_entered(body: Node3D):
	if body.is_in_group("Enemy"):  # If the bullet hits an enemy
		# Destroy the enemy on impact (you can adjust this to your needs)
		body.queue_free()  # Remove the enemy from the scene
		
		print("Bullet hit the enemy!")
		queue_free()  # Destroy the bullet on impact

# Get the closest enemy in range
func get_closest_enemy() -> Node3D:
	var closest_enemy : Node3D = null
	var closest_distance : float = 99999999999999  # Start with an infinitely large distance

	# Loop through all nodes in the "Enemy" group to find the closest one
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if enemy.has_method("stop_moving"):  # If the node has the required method
			var distance = global_transform.origin.distance_to(enemy.global_transform.origin)
			if distance < closest_distance:
				closest_enemy = enemy
				closest_distance = distance
		else:
			print(enemy.name, "does not have the 'stop_moving' method!")

	# Final check before returning
	if closest_enemy:
		print("Returning closest enemy:", closest_enemy.name)
	else:
		print("No valid enemies found!")

	return closest_enemy


# Use _process for continuous movement and collision checking
func _process(delta):
	if target:
		# Continuously move the bullet towards the enemy
		var motion = direction * speed * delta
		move_and_collide(motion)  # Move and check for collisions
