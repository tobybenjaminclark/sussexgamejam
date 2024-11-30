extends Node3D

@export var particle_scene: PackedScene
var particle_instance: Node3D

func _ready():
	# Initialize or preload the particle scene.
	particle_instance = particle_scene.instantiate()
	add_child(particle_instance)

func shoot():
	# This method can be triggered when the gun is fired.
	particle_instance.position = global_position # Set particle position to gun's position
	particle_instance.emitting = true # Start emitting particles

	# Optionally, disable emitting after a brief delay if the effect is short-lived.
	await get_tree().create_timer(0.1).timeout # Wait for 0.1 seconds
	particle_instance.emitting = false
