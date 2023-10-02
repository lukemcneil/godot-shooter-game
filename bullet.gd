extends RigidBody2D

@export var speed = 500

func init(start_position: Vector2, start_rotation: float, color: Color):
	position = start_position
	rotation = start_rotation
	var velocity = Vector2(speed, 0.0)
	linear_velocity = velocity.rotated(rotation)
	$ColorRect.color = color

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
