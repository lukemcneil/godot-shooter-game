extends Node

# map from player integer to the player node
var player_nodes = {}
var screen_size

func _ready():
	screen_size = get_window().size
	PlayerManager.player_joined.connect(spawn_player)
	PlayerManager.player_left.connect(delete_player)
	PlayerManager.join_all_unjoined_devices()
	$Walls/WallRight.position = Vector2(screen_size.x, 0)
	$Walls/WallBottom.position = Vector2(0, screen_size.y)
	SettingsManager.toggle_bullets_bounce.connect(toggle_bullets_bounce)

func _process(_delta):
	PlayerManager.handle_join_input()
	$FPS.text = str(Engine.get_frames_per_second())

func spawn_player(player: int, device: int):
	# create the player node
	var player_scene = load("res://player.tscn")
	var player_node = player_scene.instantiate()
	player_nodes[player] = player_node
	
	# let the player know which device controls it
	player_node.init(player, device)
	
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

func enable_bit(mask: int, index: int) -> int:
	return mask | (1 << index)

func disable_bit(mask: int, index: int) -> int:
	return mask & ~(1 << index)

func toggle_bullets_bounce(value):
	if value:
		$Walls.collision_layer = enable_bit($Walls.collision_layer, 1)
	else:
		$Walls.collision_layer = disable_bit($Walls.collision_layer, 1)
