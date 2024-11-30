extends CharacterBody3D

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5

var money: int = 0

@export var money_label: Label  # Allows setting the Label path in the Inspector

func _ready() -> void:
	update_money_label()

func add_money(amount: int) -> void:
	money += amount
	update_money_label()

func remove_money(amount: int) -> void:
	money = max(0, money - amount)
	update_money_label()

func update_money_label() -> void:
	money_label.text = "Money: %d" % money
	
func _physics_process(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY  # Set the y velocity to make the player jump

	# Get the input direction for horizontal movement (x and z axis).
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Handle horizontal movement (x and z).
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
