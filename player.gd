extends Area2D

@export var speed = 400

signal leave

var player: int
var input

# call this function when spawning this player to set up the input object based on the device
func init(player_num: int):
	player = player_num
	var device = PlayerManager.get_player_device(player)
	input = DeviceInput.new(device)
#	$Player.text = "%s" % player_num

func _process(delta):
	var move = input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += move * delta * speed
	
	# let the player leave by pressing the "join" button
	if input.is_action_just_pressed("join"):
		
		PlayerManager.leave(player)
