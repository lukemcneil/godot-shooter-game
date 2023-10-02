extends RigidBody2D

@export var speed = 500
var player: int

func init(start_position: Vector2, start_rotation: float, color: Color, player_number: int):
	position = start_position
	rotation = start_rotation
	var velocity = Vector2(speed, 0.0)
	linear_velocity = velocity.rotated(rotation)
	player = player_number
	modulate = color

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
