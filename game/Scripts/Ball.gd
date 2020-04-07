extends Area2D

var velocity
var screen_size
export var min_speed = 150
export var max_speed = 200
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x / 2, screen_size.y / 2)
	velocity = Vector2(1, 0)
	var direction = rand_range(-PI, PI)
	velocity = velocity.rotated(direction) * rand_range(min_speed, max_speed)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position + velocity * delta
	if (position.x > screen_size.x):
		position.x = screen_size.x
		velocity.x = -velocity.x
	elif (position.x < 0):
		position.x = 0
		velocity.x = -velocity.x
	
	if (position.y > screen_size.y):
		position.y = screen_size.y
		velocity.y = -velocity.y
	elif (position.y < 0):
		position.y = 0
		velocity.y = -velocity.y
