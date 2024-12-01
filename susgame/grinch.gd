extends CharacterBody3D

const SPEED = 0.5
const FOLLOW_DISTANCE = 1.0 

@export var coin_scene: PackedScene  # Reference to the "coin" prefab

var animation_player: AnimationPlayer
var santa: Node3D
var is_dead: bool = false
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var collision_area: Area3D = $Area3D  # Reference to the Area3D node

func _ready() -> void:
	animation_player = $grinch2/AnimationPlayer
	santa = get_parent().get_node_or_null("/root/Node3D2/Santa")
	
	# Ensure the NavigationAgent is set up
	nav_agent.set_target_position(santa.global_transform.origin)
	nav_agent.radius = 2.0
	nav_agent.height = 2.0
	nav_agent.avoidance_enabled = true
	nav_agent.target_desired_distance = 0.5
	nav_agent.set_navigation_map(get_node("/root/Node3D2/NavigationRegion3D").navigation_mesh)

	if animation_player == null:
		print("AnimationPlayer not found!")
	else:
		print("AnimationPlayer initialized successfully")

	if santa == null:
		print("Santa node not found!")
	else:
		print("Santa initialized successfully")

	# Connect the body_entered signal to the Area3D node
	collision_area.connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector3.ZERO
		return

	# Calculate distance to Santa
	var distance_to_santa = global_transform.origin.distance_to(santa.global_transform.origin)

	if distance_to_santa > FOLLOW_DISTANCE:
		nav_agent.set_target_position(santa.global_transform.origin)
		if not nav_agent.is_navigation_finished():
			var next_point = nav_agent.get_next_path_position()
			var direction = (next_point - global_transform.origin).normalized()
			
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED

			rotation.y = atan2(-direction.x, -direction.z)
			
			if not animation_player.is_playing() or animation_player.current_animation != "grinch_walk":
				animation_player.play("grinch_walk")
		else:
			stop_moving()
	else:
		stop_moving()

	move_and_slide()

func stop_moving() -> void:
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.z = move_toward(velocity.z, 0, SPEED)
	if animation_player.current_animation != "grinch_idle":
		animation_player.play("grinch_idle")

# Handle collision with bullets
func _on_body_entered(body: Node3D) -> void:
	print("hit by body: ", body.name, body.get_groups())
	if body.is_in_group("Bullet"):
		if not is_dead:
			is_dead = true
			animation_player.play("grinch_die")
			print("Grinch hit by a bullet!")
			
			# Wait for death animation to finish before spawning a coin and freeing the Grinch
			await get_tree().create_timer(animation_player.current_animation_length).timeout
			spawn_coin()
			queue_free()

func spawn_coin():
	if coin_scene:
		var coin = coin_scene.instantiate()
		coin.global_transform.origin = global_transform.origin  # Spawn at Grinch's position
		get_tree().current_scene.add_child(coin)
	else:
		print("Coin scene is not assigned!")
