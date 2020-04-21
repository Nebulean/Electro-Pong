extends RigidBody2D

class_name Ball

var screen_size
export var min_speed = 150
export var max_speed = 200
export var manual_state = false



func _ready():
	print_debug("readying")
	if not manual_state:
		screen_size = get_viewport_rect().size
		position = Vector2(screen_size.x / 2, screen_size.y / 2)
		linear_velocity = Vector2(1, 0)
		var direction = rand_range(-PI, PI)
		linear_velocity = linear_velocity.rotated(direction) * rand_range(min_speed, max_speed)
		linear_velocity = Vector2(0,0)
	
