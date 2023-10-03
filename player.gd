extends CharacterBody2D

@export var speed = 400
@export var bullet_scene: PackedScene
@export var shoot_delay = 0.1
@export var starting_health = 3
@export var invincible = false
var color
var screen_size
var health

signal leave

var player: int
var device_num: int
var input

const colors = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.PURPLE,
	Color.BLACK,
	Color.ORANGE,
	Color.YELLOW,
	Color.BROWN
]

# call this function when spawning this player to set up the input object based on the device
func init(player_num: int, device_num: int):
	player = player_num
	self.device_num = device_num
	var device = PlayerManager.get_player_device(player)
	input = DeviceInput.new(device)

func _ready():
	screen_size = get_viewport_rect().size
	$ShootTimer.wait_time = shoot_delay
	$ShootTimer.start()
	rotation = randf() * 2 * PI
	color = colors[device_num+1]
	$Body.color = color
	$Gun.color = color
	health = starting_health

func _process(delta):
	var move = input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move * speed
	move_and_slide()
	
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
	bullet.init($BulletSpawnMarker.global_position, rotation, color, player)
	get_parent().add_child(bullet)

func _on_player_hit_box_body_entered(body):
	if body.is_in_group("bullets") and not invincible:
		body.queue_free()
		health -= 1
		if health == 0:
			PlayerManager.leave(player)
