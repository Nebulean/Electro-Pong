extends RigidBody2D

class_name Ball

var screen_size
export var min_speed = 150
export var max_speed = 200
export var charge = -1

func _ready():
	screen_size = get_viewport_rect().size
	position = Vector2(screen_size.x / 2, screen_size.y / 2)
	linear_velocity = Vector2(1, 0)
	var direction = rand_range(-PI, PI)
	linear_velocity = linear_velocity.rotated(direction) * rand_range(min_speed, max_speed)
	set_sprite()
		
func set_sprite():
	if (charge >= 0):
		$Sprite.animation = "positive"
	else :
		$Sprite.animation = "negative"

func _change_polarity():
	if (charge < 0):
		$Polarity_inverter.start()
		print_debug("Polarity changed")
		charge *= -1
		set_sprite()

func _on_Polarity_inverter_timeout():
	$Polarity_inverter.stop()
	print_debug("Polarity reset")
	charge *= -1
	set_sprite()
