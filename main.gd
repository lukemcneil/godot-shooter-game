extends Node

@export var player_speed = 400
@export var shoot_delay = 0.1
@export var starting_health = 3
@export var invincible = false

# map from player integer to the player node
var player_nodes = {}
var screen_size
signal pause

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

func _ready():
	screen_size = get_window().size
	PlayerManager.player_joined.connect(spawn_player)
	PlayerManager.player_left.connect(delete_player)
	PlayerManager.join_all_unjoined_devices()
	$Walls/WallRight.position = Vector2(screen_size.x, 0)
	$Walls/WallBottom.position = Vector2(0, screen_size.y)
	$SettingsWindow.init_settings(player_speed, shoot_delay, starting_health, invincible)

func _process(_delta):
	PlayerManager.handle_join_input()
	$FPS.text = str(Engine.get_frames_per_second())

func spawn_player(player: int, device: int):
	# create the player node
	var player_scene = load("res://player.tscn")
	var player_node = player_scene.instantiate()
	player_nodes[player] = player_node
	
	player_node.update_settings(player_speed, shoot_delay, starting_health, invincible)
	# let the player know which device controls it
	player_node.init(player, device, colors[device+1])
	player_node.change_color.connect(on_change_color)
	
	# add the player to the tree
	add_child(player_node)
	
	# random spawn position
	var screenSize: Vector2 = get_viewport().get_visible_rect().size
	player_node.position = Vector2(randf_range(0, screenSize.x), randf_range(0, screenSize.y))

func delete_player(player: int):
	player_nodes[player].queue_free()
	player_nodes.erase(player)

func _input(event):
	if event.is_action_pressed("pause"):
		$SettingsWindow.visible = not $SettingsWindow.visible

func _on_settings_window_new_settings(player_speed, shoot_delay, starting_health, invincible):
	self.player_speed = player_speed
	self.shoot_delay = shoot_delay
	self.starting_health = starting_health
	self.invincible = invincible
	for player in player_nodes.values():
		player.update_settings(player_speed, shoot_delay, starting_health, invincible)

func on_change_color(color, device):
	colors[device+1] = color
