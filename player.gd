extends Area2D

@export var speed = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	print("readys")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += direction * speed * delta
