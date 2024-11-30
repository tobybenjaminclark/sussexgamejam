extends Area3D

@export var coin_value: int = 10
@export var money_label: Label  # Reference to the label, set this in the inspector

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_player_collected"))

func _on_player_collected(body: Node) -> void:
	print("COIN: collision")
	print(body.get_groups())  # Print out the groups to ensure "Player" is there
	
	if body.is_in_group("Player"):  # Check if the entering body is the player
		print("Player detected")

		# Access the player's add_money method directly
		var player = body  # Assuming the player has a script with `add_money` method
		if player.has_method("add_money"):
			print("Adding money to player")
			player.add_money(coin_value)  # Add the coin value to the player's money
			player.money_label.text = "Money: " + str(player.money)  # Update the label

		get_parent().queue_free()  # Remove the coin after collection
