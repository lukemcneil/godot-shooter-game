extends RigidBody2D
var speed: int
var player: int

func init(start_position: Vector2, start_rotation: float, color: Color, player_number: int, speed: int, size: float, gravity: float, bullets_hit_bullets: bool):
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
	if bullets_hit_bullets:
		collision_mask = enable_bit(1, collision_mask)
	else:
		collision_mask = disable_bit(1, collision_mask)
	SettingsManager.toggle_bullets_hit_bullets.connect(toggle_bullets_hit_bullets)

func enable_bit(mask: int, index: int) -> int:
	return mask | (1 << index)

func disable_bit(mask: int, index: int) -> int:
	return mask & ~(1 << index)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func set_bullets_gravity(value):
	gravity_scale = value

func toggle_bullets_hit_bullets(value):
	if value:
		collision_mask = enable_bit(1, collision_mask)
	else:
		collision_mask = disable_bit(1, collision_mask)
