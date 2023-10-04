extends CharacterBody2D

@export var bullet_scene: PackedScene

var speed: int
var shoot_delay: float
var starting_health: int
var invincible: bool
var bullet_speed: int
var bullets_bounce: bool
var bullet_size: float
var color
var health

signal leave
signal change_color(color: Color, device: int)

var player: int
var device_num: int
var input

# call this function when spawning this player to set up the input object based on the device
func init(player_num: int, device_num: int, color: Color):
	player = player_num
	self.device_num = device_num
	var device = PlayerManager.get_player_device(player)
	input = DeviceInput.new(device)
	rotation = randf() * 2 * PI
	self.color = color
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
		$ShootTimer.set_paused(not $ShootTimer.is_paused())
#
	if input.is_action_just_pressed("change_color"):
		var new_color = Color(randf(), randf(), randf())
		emit_signal("change_color", new_color, device_num)
		self.color = new_color
		$Body.color = new_color
		$Gun.color = new_color

func _on_shoot_timer_timeout():
	var bullet = bullet_scene.instantiate()
	bullet.init($BulletSpawnMarker.global_position, rotation, color, player, bullet_speed, bullets_bounce, bullet_size)
	get_parent().add_child(bullet)

func _on_player_hit_box_body_entered(body):
	if body.is_in_group("bullets") and not invincible:
		body.queue_free()
		health -= 1
		if health == 0:
			PlayerManager.leave(player)

func update_settings(player_speed, shoot_delay, starting_health, invincible, bullet_speed, bullets_bounce, bullet_size):
	self.speed = player_speed
	self.shoot_delay = shoot_delay
	if shoot_delay > 0:
		$ShootTimer.wait_time = shoot_delay
	self.starting_health = starting_health
	self.invincible = invincible
	self.bullet_speed = bullet_speed
	self.bullets_bounce = bullets_bounce
	self.bullet_size = bullet_size
