extends CharacterBody2D

@export var speed = 400
@export var bullet_scene: PackedScene
@export var shoot_delay = 0.1
var color
var screen_size

signal leave

var player: int
var input

const colors = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.BLACK,
	Color.PURPLE,
	Color.ORANGE,
	Color.YELLOW,
	Color.BROWN
]

# call this function when spawning this player to set up the input object based on the device
func init(player_num: int):
	player = player_num
	var device = PlayerManager.get_player_device(player)
	input = DeviceInput.new(device)
	$ShootTimer.wait_time = shoot_delay
	rotation = randf() * 2 * PI
	color = colors[player_num]
	$Body.color = color
	$Gun.color = color

func _ready():
	screen_size = get_viewport_rect().size	

func _process(delta):
	var move = input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += move * delta * speed
	position = position.clamp(Vector2.ZERO, screen_size)
	
	var look: Vector2 = input.get_vector("look_left", "look_right", "look_up", "look_down")
	if !look.is_zero_approx():
		rotation = look.angle()
	
	# let the player leave by pressing the "join" button
	if input.is_action_just_pressed("join"):
		PlayerManager.leave(player)

	if input.is_action_just_pressed("toggle_shoot"):
		if $ShootTimer.is_stopped():
			$ShootTimer.start()
		else:
			$ShootTimer.stop()

func _on_shoot_timer_timeout():
	var bullet = bullet_scene.instantiate()
	bullet.init($BulletSpawnMarker.global_position, rotation, color)
	get_parent().add_child(bullet)
