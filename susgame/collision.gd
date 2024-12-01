@tool
extends MeshInstance3D

func _ready():
	if not Engine.is_editor_hint():
		return

	# Ensure there's a StaticBody3D child
	var static_body = $StaticBody3D
	if not static_body:
		static_body = StaticBody3D.new()
		add_child(static_body)
		static_body.owner = self.owner

	# Ensure there's a CollisionShape3D child
	var collision_shape = static_body.get_node_or_null("CollisionShape3D")
	if not collision_shape:
		collision_shape = CollisionShape3D.new()
		static_body.add_child(collision_shape)
		collision_shape.owner = self.owner

	# Create a BoxShape3D based on mesh bounds
	var box_shape = BoxShape3D.new()
	var aabb = mesh.get_aabb()  # Get mesh bounding box
	box_shape.extents = aabb.size * 0.5
	collision_shape.shape = box_shape
	static_body.global_transform = global_transform  # Sync position and rotation
