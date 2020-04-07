extends Area2D

var velocity
var screen_size
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x / 2, screen_size.y / 2)
	velocity = Vector2(1, 0)
	var direction = rand_range(-PI, PI)
	velocity = velocity.rotated(direction)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + velocity * delta
