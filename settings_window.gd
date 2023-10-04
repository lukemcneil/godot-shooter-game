extends VBoxContainer

signal new_settings(player_speed: int, shoot_delay: float, starting_health: int, invincible: bool)

var player_speed: int
var shoot_delay: float
var starting_health: int
var invincible: bool

func init_settings(player_speed, shoot_delay, starting_health, invincible):
	self.player_speed = player_speed
	self.shoot_delay = shoot_delay
	self.starting_health = starting_health
	self.invincible = invincible
	$PlayerSpeedContainer/LineEdit.text = str(player_speed)
	$ShootDelayContainer/LineEdit.text = str(shoot_delay)
	$StartingHealthContainer/LineEdit.text = str(starting_health)
	$InvincibleContainer/CheckBox.button_pressed = invincible

func emit_settings():
	emit_signal("new_settings", player_speed, shoot_delay, starting_health, invincible)

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
