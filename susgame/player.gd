extends CharacterBody3D

const SPEED = 2
const JUMP_VELOCITY = 4.5

var animation_player : AnimationPlayer  # Declare AnimationPlayer variable

func _ready() -> void:
	animation_player = $santa4/AnimationPlayer
	if animation_player == null:
		print("AnimationPlayer not found!")
	else:
		print("AnimationPlayer initialized successfully")

func _physics_process(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3.ZERO

	# Determine the direction based on input
	if input_dir.x < 0:
		direction = Vector3(-1, 0, 0)  # Left
		rotation.y = deg_to_rad(-90)  # Face left
	elif input_dir.x > 0:
		direction = Vector3(1, 0, 0)  # Right
		rotation.y = deg_to_rad(90)  # Face right
	elif input_dir.y < 0:
		direction = Vector3(0, 0, -1)  # Down
		rotation.y = deg_to_rad(180)  # Face down (Z forward)
	elif input_dir.y > 0:
		direction = Vector3(0, 0, 1)  # Up
		rotation.y = deg_to_rad(0)  # Face up (Z back)

	# Set the movement velocity
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		# Play the walking animation if moving
		if not animation_player.is_playing() or animation_player.current_animation != "walk":
			animation_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		# Play the idle animation if not moving
		if not animation_player.is_playing() or animation_player.current_animation != "idle":
			animation_player.play("idle")

	move_and_slide()
