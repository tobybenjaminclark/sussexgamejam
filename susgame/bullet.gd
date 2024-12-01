extends RigidBody3D

@export var speed : float = 20.0  # Bullet speed
@export var lifetime : float = 5.0  # Time after which the bullet will be destroyed
var direction : Vector3  # Direction in which the bullet will travel
var player : Node3D  # Reference to the player node

# Called when the bullet is ready
func _ready():
	set_as_top_level(true)  # Correct method to make the bullet move independently

	# Find the player node (adjust the path as needed)
	player = get_node_or_null("/root/Node3D2/Santa")
	if player:
		# Calculate direction towards the player
		direction = (player.global_transform.origin - global_transform.origin).normalized()

		# Set the bullet's velocity to move towards the player
		linear_velocity = direction * speed
	else:
		print("No player found in bullet!")
		
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

# Optional: Detect collisions and destroy the player
func _on_Bullet_body_entered(body: Node3D):
	if body.is_in_group("Player"):  # If the bullet hits the player
		# Destroy the player when hit by the bullet
		body.queue_free()  # Remove the player from the scene
		
		print("Bullet hit the player!")
		queue_free()  # Destroy the bullet on impact
		
# Use _process for continuous movement and collision checking
func _process(delta):
	if player:
		# Move the bullet continuously towards the player
		var motion = direction * speed * delta
		move_and_collide(motion)  # Move and check for collisions
