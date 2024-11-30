extends CharacterBody3D

const SPEED = 1
const JUMP_VELOCITY = 4.5
const FOLLOW_DISTANCE = 1.0  # Minimum distance to stop following

var animation_player : AnimationPlayer  # Declare AnimationPlayer variable
var santa : Node3D  # Reference to the target `santa`

func _ready() -> void:
	animation_player = $grinch2/AnimationPlayer
	santa = get_parent().get_node("Santa")
	if animation_player == null:
		print("AnimationPlayer not found!")
	else:
		print("AnimationPlayer initialized successfully")

	if santa == null:
		print("Santa node not found!")
	else:
		print("Santa initialized successfully")

func _physics_process(delta: float) -> void:
	# Calculate direction to santa
	var to_santa = (santa.global_transform.origin - global_transform.origin)
	var distance_to_santa = to_santa.length()

	# Stop moving if within follow distance
	if distance_to_santa > FOLLOW_DISTANCE:
		var direction = to_santa.normalized()

		# Update velocity to move towards santa
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		# Rotate grinch to face santa
		rotation.y = atan2(-direction.x, -direction.z)

		# Play walking animation if moving
		if not animation_player.is_playing() or animation_player.current_animation != "grinch_walk":
			animation_player.play("grinch_walk")
	else:
		# Stop moving if close to santa
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Apply gravity and movement
	move_and_slide()
