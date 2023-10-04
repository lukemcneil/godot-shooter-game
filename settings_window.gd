extends VBoxContainer

signal new_settings(player_speed: int, shoot_delay: float, starting_health: int, bullet_speed: int, invincible: bool, bullet_size: float)

func _ready():
	$PlayerSpeedContainer/LineEdit.text = str(SettingsManager.player_speed)
	$ShootDelayContainer/LineEdit.text = str(SettingsManager.shoot_delay)
	$StartingHealthContainer/LineEdit.text = str(SettingsManager.starting_health)
	$InvincibleContainer/CheckBox.button_pressed = SettingsManager.invincible
	$BulletSpeedContainer/LineEdit.text = str(SettingsManager.bullet_speed)
	$BulletsBounceContainer/CheckBox.button_pressed = SettingsManager.bullets_bounce
	$BulletSizeContainer/LineEdit.text = str(SettingsManager.bullet_size)

func _on_player_speed_edit_text_changed(new_text):
	SettingsManager.player_speed = int(new_text)
	SettingsManager.emit_signal("settings_updated")

func _on_shoot_delay_line_edit_text_changed(new_text):
	SettingsManager.shoot_delay = float(new_text)
	SettingsManager.emit_signal("settings_updated")

func _on_starting_health_line_edit_text_changed(new_text):
	SettingsManager.starting_health = int(new_text)
	SettingsManager.emit_signal("settings_updated")

func _on_invincible_check_box_toggled(button_pressed):
	SettingsManager.invincible = button_pressed
	SettingsManager.emit_signal("settings_updated")

func _on_bullets_bounce_check_box_toggled(button_pressed):
	SettingsManager.bullets_bounce = button_pressed
	SettingsManager.emit_signal("toggle_bullets_bounce", button_pressed)
	SettingsManager.emit_signal("settings_updated")

func _on_bullet_speed_line_edit_text_changed(new_text):
	SettingsManager.bullet_speed = int(new_text)
	SettingsManager.emit_signal("settings_updated")

func _on_clear_bullets_button_pressed():
	SettingsManager.clear_bullets()
	SettingsManager.emit_signal("settings_updated")

func _on_bullet_size_line_edit_text_changed(new_text):
	SettingsManager.bullet_size = float(new_text)
	SettingsManager.emit_signal("settings_updated")
