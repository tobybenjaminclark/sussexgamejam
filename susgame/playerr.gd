extends CharacterBody3D

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

var money: int = 0

@export var money_label: Label  # Allows setting the Label path in the Inspector

# Reference to the coin area
var coin: Node3D  # The coin area will be assigned in the _ready() function

func _ready() -> void:
	# Get the reference to the coin node and connect the signal
	coin = get_parent().get_node("Goin").get_node("Area3D")  # Replace "Coin" with the correct path to your coin node
	if coin:
		coin.connect("body_entered", Callable(self, "_on_coin_collected"))
	else:
		print("Error: Coin node not found. Make sure the path is correct.")

# Method to add money
func add_money(amount: int) -> void:
	money += amount

# Method to remove money
func remove_money(amount: int) -> void:
	money = max(0, money - amount)

# Handle physics-based movement and jumping
func _physics_process(delta: float) -> void:
	# Handle jump logic: Trigger when the user presses the jump button and the player is on the ground
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY  # Set the y velocity to make the player jump

	# Get the input direction for horizontal movement (x and z axis).
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Handle horizontal movement (x and z).
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# Smooth stopping if no input is given
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	# Move the character using the calculated velocity.
	move_and_slide()

# This function is called when the player collides with a coin
func _on_coin_collected(body: Node) -> void:
	print("collected")
	print("Collision detected with body:", body.name)
	print("Groups of body:", body.get_groups())
	if body.name == "Player": # Check if the body that entered the area is a coin
		print("yes")
		add_money(10)  # Add 10 money (you can change this amount)
		money_label.text = str("Money: ", money)  # Update the label text to display the current money
		coin.get_parent().queue_free()  # Remove the coin from the scene after being collected
