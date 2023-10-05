extends CharacterBody2D

@export var bullet_scene: PackedScene

var speed: int
var shoot_delay: float
var starting_health: int
var invincible: bool
var bullet_speed: int
var bullet_size: float
var gravity: float
var bullets_hit_bullets: bool
var color: Color
var health

signal leave

var player: int
var device_num: int
var input

# call this function when spawning this player to set up the input object based on the device
func init(player_num: int, device_num: int):
	player = player_num
	self.device_num = device_num
	var device = PlayerManager.get_player_device(player)
	input = DeviceInput.new(device)
	rotation = randf() * 2 * PI
	
	sync_data_with_settings_manager()
	
	SettingsManager.settings_updated.connect(sync_data_with_settings_manager)
	
	health = starting_health
	sync_color_with_settings()

func sync_data_with_settings_manager():
	speed = SettingsManager.player_speed
	shoot_delay = SettingsManager.shoot_delay
	if shoot_delay > 0:
		$ShootTimer.wait_time = shoot_delay
	starting_health = SettingsManager.starting_health
	invincible = SettingsManager.invincible
	bullet_speed = SettingsManager.bullet_speed
	bullet_size = SettingsManager.bullet_size
	gravity = SettingsManager.gravity
	bullets_hit_bullets = SettingsManager.bullets_hit_bullets

func _process(delta):
	var move = input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move * speed
	move_and_slide()

	var look: Vector2 = input.get_vector("look_left", "look_right", "look_up", "look_down")
	if !look.is_zero_approx():
		# Calculate the difference between current and target rotations
		var rotation_difference = rotation - look.angle() + PI

		var max_rotation = 10*delta

		# Normalize the rotation difference to be within -π to π radians
		if rotation_difference > PI:
			rotation_difference -= 2 * PI
		elif rotation_difference < -PI:
			rotation_difference += 2 * PI

		# Ensure the rotation stays within the maximum limit
		if rotation_difference > max_rotation:
			rotation_difference = max_rotation
		elif rotation_difference < -max_rotation:
			rotation_difference = -max_rotation
		else:
			rotation = look.angle()
			return

		# Calculate the new rotation after limiting
		rotation += rotation_difference

	# let the player leave by pressing the "join" button
	if input.is_action_just_pressed("join"):
		PlayerManager.leave(player)

	if input.is_action_just_pressed("toggle_shoot"):
		$ShootTimer.set_paused(not $ShootTimer.is_paused())
#
	if input.is_action_just_pressed("change_color"):
		var new_color = Color(randf(), randf(), randf())
		SettingsManager.colors[device_num+1] = new_color
		sync_color_with_settings()

func sync_color_with_settings():
	self.color = SettingsManager.colors[device_num+1]
	$Body.color = color
	$Gun.color = color

func _on_shoot_timer_timeout():
	var bullet = bullet_scene.instantiate()
	bullet.init($BulletSpawnMarker.global_position, rotation, color, player, bullet_speed, bullet_size, gravity, bullets_hit_bullets)
	get_parent().add_child(bullet)

func _on_player_hit_box_body_entered(body):
	if body.is_in_group("bullets") and not invincible:
		body.queue_free()
		health -= 1
		if health == 0:
			PlayerManager.leave(player)
