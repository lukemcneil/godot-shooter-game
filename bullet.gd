extends RigidBody2D
var speed: int
var player: int

func init(start_position: Vector2, start_rotation: float, color: Color, player_number: int, speed: int, size: float, gravity: float):
	position = start_position
	rotation = start_rotation
	var velocity = Vector2(speed, 0.0)
	linear_velocity = velocity.rotated(rotation)
	player = player_number
	modulate = color
	for node in get_children():
		node.position.x = 100 * size / 2
		node.scale = Vector2(size, size)
	gravity_scale = gravity
	SettingsManager.set_bullets_gravity.connect(set_bullets_gravity)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func set_bullets_gravity(value):
	gravity_scale = value
