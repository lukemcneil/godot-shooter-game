extends RigidBody2D
var speed: int
var player: int

func init(start_position: Vector2, start_rotation: float, color: Color, player_number: int, speed: int, bounce: bool, size: float):
	position = start_position
	rotation = start_rotation
	var velocity = Vector2(speed, 0.0)
	linear_velocity = velocity.rotated(rotation)
	player = player_number
	modulate = color
	if bounce:
		collision_mask = enable_bit(collision_mask, 2)
	else:
		collision_mask = disable_bit(collision_mask, 2)
	for node in get_children():
		node.position.x = 100 * size / 2
		node.scale = Vector2(size, size)

func enable_bit(mask: int, index: int) -> int:
	return mask | (1 << index)

func disable_bit(mask: int, index: int) -> int:
	return mask & ~(1 << index)

func do_not_bounce():
	collision_mask = disable_bit(collision_mask, 2)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
