extends Area3D

signal coin_collected  # Custom signal for when the coin is collected

func _ready() -> void:
	# Connect the body_entered signal to the _on_coin_collected method
	connect("body_entered", Callable(self, "_on_coin_collected"))


# This function is triggered when something enters the coin's area
func _on_coin_collected(body: Node) -> void:
	if body.is_in_group("player"):  # Check if the body is part of the "player" group
		print("Coin collected by player!")
		emit_signal("coin_collected")  # Emit a signal when the coin is collected
		queue_free()  # Remove the coin from the scene
