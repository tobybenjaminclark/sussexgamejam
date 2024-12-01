extends Node3D

# Preload the character scene you want to spawn
@export var character_scene : PackedScene

# Declare the timer variable
var spawn_timer: Timer

# Called when the node enters the scene tree for the first time
func _ready():
	# Create and set up the timer
	spawn_timer = Timer.new()
	add_child(spawn_timer)  # Add the timer as a child node
	spawn_timer.wait_time = 10.0  # Set the interval to 5 seconds (change to your desired interval)
	spawn_timer.autostart = true  # Start the timer automatically
	spawn_timer.connect("timeout", Callable(self, "_on_Timer_timeout"))  # Connect the timer's timeout signal to the handler function

	# Initial spawn (optional if you want to spawn one character immediately)
	spawn_character()

# This function is called when the timer times out (every 5 seconds or your interval)
func _on_Timer_timeout():
	print("timer is done")
	spawn_character()

# Function to spawn the character
func spawn_character():
	print("Spawning character...")
	print("there is a character scene")
	# Instantiate the character and add it to the scene
	var character = character_scene.instantiate()
	add_child(character)

	# Add the spawned character to the "Enemy" group
	character.add_to_group("Enemy")
	spawn_timer.start()
	
