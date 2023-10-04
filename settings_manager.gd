extends Node

signal settings_updated
signal toggle_bullets_bounce(value)
signal set_bullets_gravity(value)

@export var player_speed = 400
@export var shoot_delay = 0.1
@export var starting_health = 10
@export var invincible = false
@export var bullet_speed = 600
@export var bullets_bounce = false
@export var bullet_size = 0.2
@export var gravity = 0
@export var colors = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.PURPLE,
	Color.BLACK,
	Color.ORANGE,
	Color.YELLOW,
	Color.BROWN
]

func clear_bullets():
	get_tree().call_group("bullets", "queue_free")
