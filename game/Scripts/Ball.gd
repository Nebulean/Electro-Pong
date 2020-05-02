extends RigidBody2D

class_name Ball

var screen_size
var magnetic_active = 0
var elec_att_active_p1 = 0
var elec_att_active_p2 = 0
var ball_area1 = 0
var ball_area2 = 0
var angle_p1
var angle_p2
export var min_speed = 150
export var max_speed = 200
export var charge = -1
export var B = 0.01
export var E = 0.01

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

func execute_magnetic():
	magnetic_active = 1
	$Magnetic_Timer.start()

func _integrate_forces(state):
	if magnetic_active == 1:
		set_applied_force(charge*B*Vector2(linear_velocity.y, -linear_velocity.x))
	elif elec_att_active_p1 == 1 and ball_area1 == 1:
		set_applied_force(charge*E*Vector2(cos(angle_p1), sin(angle_p1)))
	elif elec_att_active_p2 == 1 and ball_area2 == 1:
		set_applied_force(charge*E*Vector2(cos(angle_p2), sin(angle_p2)))
	else:
		set_applied_force(Vector2(0, 0))

func _on_Magnetic_Timer_timeout():
	$Magnetic_Timer.stop()
	print_debug("Magnetic field stops")
	magnetic_active = 0
