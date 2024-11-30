extends Area3D

@export var coin_value: int = 10
@export var money_label: Label  # Reference to the label, set this in the inspector

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_player_collected"))

func _on_player_collected(body: Node) -> void:
	print("COIN: collision")
	
	if body.is_in_group("Player"):  # Check if the entering body is the player
		var player_script = body.get_script()
		if player_script and player_script.has_method("add_money"):
			body.add_money(coin_value)  # Call the `add_money` function in the player script
		if money_label:
			money_label.text = "Money: " + str(body.money)  # Update the label
		queue_free()  # Remove the coin after collection
