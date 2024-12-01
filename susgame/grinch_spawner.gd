extends Node3D

# Preload the character scene you want to spawn
@export var character_scene : PackedScene

# Called when the node enters the scene tree for the first time
func _ready():
	# Add the timer node and start it
	var timer = $Timer
	timer.start()

# This function is called when the timer times out (every 5 minutes)
func _on_Timer_timeout():
	spawn_character()

# Function to spawn the character
func spawn_character():
	if character_scene:
		# Instantiate the character and add it to the scene
		var character = character_scene.instantiate()
		add_child(character)

		# Add the spawned character to the "enemy" group
		character.add_to_group("Enemy")
