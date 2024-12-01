extends CharacterBody3D

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

var money: int = 0

@export var money_label: Label  # Allows setting the Label path in the Inspector

# Reference to the list of coin areas
var coins: Array = []  # An array to store the references to all coin areas

func _ready() -> void:
	# Find all nodes in the "Goin" group and add them to the `coins` array
	var coin_nodes = get_tree().get_nodes_in_group("Goin")
	for coin_node in coin_nodes:
		if coin_node is Area3D:
			coins.append(coin_node)
			coin_node.connect("body_entered", Callable(self, "_on_coin_collected"))

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
