extends Node3D

@export var shooting_speed : float = 2.0  # Time delay between shots
@export var bullet_speed : float = 10.0  # Speed of the bullet
@export var detection_range : float = 20.0  # Range within which the tower can shoot
@export var bullet_scene : PackedScene  # Bullet scene (create a bullet as a separate scene)
@export var gun_sound : AudioStream  # Gunshot sound effect

var player : Node3D  # Reference to the player
var time_since_last_shot : float = 0.0
var audio_player : AudioStreamPlayer3D  # Audio player for the gunshot sound


func _ready():
	player = get_node_or_null("/root/Node3D/Player")
	audio_player = get_node_or_null("AudioStreamPlayer3D")
	if gun_sound and audio_player:
		audio_player.stream = gun_sound


func _process(delta):
	if player:
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
	var muzzle_node = get_node_or_null("MuzzleNode")
	get_tree().current_scene.add_child(muzzle_node)
	bullet.global_transform.origin = muzzle_node.global_transform.origin
	bullet.look_at(player.global_transform.origin, Vector3.UP)
	var direction = (player.global_transform.origin - bullet.global_transform.origin).normalized()
	var velocity = direction * bullet_speed
	if bullet is RigidBody3D:
		bullet.linear_velocity = velocity
	get_tree().current_scene.add_child(bullet)
	var muzzle_particles = muzzle_node.get_node_or_null("GPUParticles3D")
	if muzzle_particles:
		muzzle_particles.emitting = true
		var timer = Timer.new()
		timer.wait_time = 0.1
		timer.one_shot = true
		timer.timeout.connect(_stop_emitting)
		muzzle_node.add_child(timer)
		timer.start()
	if audio_player:
		audio_player.play()


func _stop_emitting():
	var muzzle_particles = get_node_or_null("MuzzleNode/GPUParticles3D")
	if muzzle_particles:
		muzzle_particles.emitting = false
