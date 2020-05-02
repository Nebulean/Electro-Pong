extends RigidBody2D

class_name Ball

onready var center_of_screen := get_viewport_rect().size/2
export var min_speed: float = 150
export var max_speed: float= 200
export var charge: float = -1
var _position_reset_needed := false
var _velocity_reset_needed := false

func _ready():
	can_sleep = false
	set_sprite()
	reset()

func reset():
	_position_reset_needed = true
	$Pause_between_rounds.start()

func _new_random_velocity() -> Vector2:
	var new_velocity := Vector2(1, 0)
	var direction := rand_range(-PI, PI)
	new_velocity = new_velocity.rotated(direction) * rand_range(min_speed, max_speed)
	return new_velocity

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if _position_reset_needed:
		var xform := state.get_transform()
		xform.origin = center_of_screen
		state.set_transform(xform)
		state.set_linear_velocity(Vector2.ZERO)
		_position_reset_needed = false
	if _velocity_reset_needed:
		state.set_linear_velocity(_new_random_velocity())
		_velocity_reset_needed = false

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

func _on_Pause_between_rounds_timeout() -> void:
	_velocity_reset_needed = true
