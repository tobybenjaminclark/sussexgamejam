extends Area3D

signal coin_collected

@export var value : int = 1

func _ready() -> void:
	self.connect("area_entered", _on_Coin_area_entered)

func _on_Coin_area_entered(area: Area3D) -> void:
	emit_signal("coin_collected", value)
	queue_free()
