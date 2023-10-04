extends VBoxContainer

signal new_settings(player_speed: int, shoot_delay: float, starting_health: int, bullet_speed: int, invincible: bool, bullet_size: float)
signal clear_bullets

var player_speed: int
var shoot_delay: float
var starting_health: int
var invincible: bool
var bullet_speed: int
var bullets_bounce: bool
var bullet_size: float

func init_settings(player_speed, shoot_delay, starting_health, invincible, bullet_speed, bullets_bounce, bullet_size):
	self.player_speed = player_speed
	self.shoot_delay = shoot_delay
	self.starting_health = starting_health
	self.invincible = invincible
	self.bullet_speed = bullet_speed
	self.bullets_bounce = bullets_bounce
	self.bullet_size = bullet_size
	$PlayerSpeedContainer/LineEdit.text = str(player_speed)
	$ShootDelayContainer/LineEdit.text = str(shoot_delay)
	$StartingHealthContainer/LineEdit.text = str(starting_health)
	$InvincibleContainer/CheckBox.button_pressed = invincible
	$BulletSpeedContainer/LineEdit.text = str(bullet_speed)
	$BulletsBounceContainer/CheckBox.button_pressed = bullets_bounce
	$BulletSizeContainer/LineEdit.text = str(bullet_size)

func emit_settings():
	emit_signal("new_settings", player_speed, shoot_delay, starting_health, invincible, bullet_speed, bullets_bounce, bullet_size)

func _on_player_speed_edit_text_changed(new_text):
	player_speed = int(new_text)
	emit_settings()

func _on_shoot_delay_line_edit_text_changed(new_text):
	shoot_delay = float(new_text)
	emit_settings()

func _on_starting_health_line_edit_text_changed(new_text):
	starting_health = int(new_text)
	emit_settings()

func _on_invincible_check_box_toggled(button_pressed):
	invincible = button_pressed
	emit_settings()

func _on_bullets_bounce_check_box_toggled(button_pressed):
	bullets_bounce = button_pressed
	emit_settings()

func _on_bullet_speed_line_edit_text_changed(new_text):
	bullet_speed = int(new_text)
	emit_settings()

func _on_clear_bullets_button_pressed():
	emit_signal("clear_bullets")

func _on_bullet_size_line_edit_text_changed(new_text):
	bullet_size = float(new_text)
	emit_settings()
