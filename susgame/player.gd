extends CharacterBody3D

const SPEED = 2
const JUMP_VELOCITY = 4.5

var animation_player : AnimationPlayer  # Declare AnimationPlayer variable
var money: int = 0  # Track the money value

@export var money_label: Label  # Reference to the Label node in the scene

var last_money: int = -1  # Track the last money value to detect changes

func _ready() -> void:
	animation_player = $santa4/AnimationPlayer
	if animation_player == null:
		print("AnimationPlayer not found!")
	else:
		print("AnimationPlayer initialized successfully")

	# Initialize the money label
	_update_money_label()

func _physics_process(delta: float) -> void:
	# Handle jump logic: Trigger when the user presses the jump button and the player is on the ground
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration using WASD.
	var direction := Vector3.ZERO
	
	if Input.is_action_pressed("move_left"):  # A or left arrow
		direction.x = -1
	elif Input.is_action_pressed("move_right"):  # D or right arrow
		direction.x = 1
	
	if Input.is_action_pressed("move_up"):  # W or up arrow
		direction.z = -1
	elif Input.is_action_pressed("move_down"):  # S or down arrow
		direction.z = 1

	# Normalize to prevent faster diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()

	# Set the movement velocity
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	# Rotate the player to face the movement direction
	if direction != Vector3.ZERO:
		rotation.y = -atan2(direction.x, 0-direction.z)  # Rotate to face the movement direction

	# Play the walking animation if moving
	if direction != Vector3.ZERO:
		if not animation_player.is_playing() or animation_player.current_animation != "walk":
			animation_player.play("walk")
	else:
		# If not moving, play idle animation
		if not animation_player.is_playing() or animation_player.current_animation != "idle":
			animation_player.play("idle")
	
	# Apply movement
	move_and_slide()

	# Update money label in every frame if money has changed
	_update_money_label_if_needed()

# Method to update the money label if the money has changed
func _update_money_label_if_needed() -> void:
	if money != last_money:
		_update_money_label()  # Update the label when money changes
		last_money = money  # Store the current money as last money

# Method to update the money label UI
func _update_money_label() -> void:
	if money_label:
		money_label.text = "Money: %d" % money

# Example method to simulate adding money (you can call this when the player collects a coin, etc.)
func add_money(amount: int) -> void:
	money += amount  # Change money value, this will trigger label update in the next frame
