extends Node

# map from player integer to the player node
var player_nodes = {}

func _ready():
	PlayerManager.player_joined.connect(spawn_player)
	PlayerManager.player_left.connect(delete_player)
	PlayerManager.join_all_unjoined_devices()

func _process(_delta):
	PlayerManager.handle_join_input()

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
