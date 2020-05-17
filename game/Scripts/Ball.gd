extends RigidBody2D

class_name Ball

onready var center_of_screen := get_viewport_rect().size/2
export var min_speed: float = 150
export var max_speed: float= 200
export var charge: float = 1
var _position_reset_needed := false
var _velocity_reset_needed := false
var _pad_normal: Vector2
var _velocity_normalization_needed := false
var magnetic_active = 0
var elec_att_active_p1 = 0
var elec_att_active_p2 = 0
var ball_area1 = 0
var ball_area2 = 0
var angle_p1
var angle_p2
export var B = 0.01
export var E = 3
var last_hit_player: Player = null

var intro = false
var intro_force = false

func _ready():
	set_sprite()
	if !intro:
		can_sleep = false
		contact_monitor = true
		contacts_reported = 1
		reset()
		$Trail.start()

func startTrail():
	$Trail.start()

func stopTrail():
	$Trail.stop()

func reset():
	_position_reset_needed = true
	$Pause_between_rounds.start()

func _new_random_velocity() -> Vector2:
	var new_velocity := Vector2(1, 0)
	var direction := rand_range(-PI, PI)
	new_velocity = new_velocity.rotated(direction) * rand_range(min_speed, max_speed)
	return new_velocity

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	# Ball reseting
	if _position_reset_needed:
		var xform := state.get_transform()
		xform.origin = center_of_screen
		state.set_transform(xform)
		state.set_linear_velocity(Vector2.ZERO)
		sleeping = true
		_position_reset_needed = false
		charge = 1
		set_sprite()
		$Trail.set_gradient(charge)
		$Trail.reset_trail()
	if _velocity_reset_needed:
		state.set_linear_velocity(_new_random_velocity())
		_velocity_reset_needed = false
		sleeping = false

	# Power-ups
	if magnetic_active == 1:
		set_applied_force(charge*B*Vector2(linear_velocity.y, -linear_velocity.x))
	elif elec_att_active_p1 == 1 and ball_area1 == 1:
		set_applied_force(-charge*E*Vector2(cos(angle_p1), sin(angle_p1)))
	elif elec_att_active_p2 == 1 and ball_area2 == 1:
		set_applied_force(-charge*E*Vector2(cos(angle_p2), sin(angle_p2)))
	elif magnetic_active == 1 and elec_att_active_p1 == 1 and ball_area1 == 1:
		set_applied_force(-charge*E*Vector2(cos(angle_p1), sin(angle_p1)) + charge*B*Vector2(linear_velocity.y, -linear_velocity.x))
	elif magnetic_active == 1 and elec_att_active_p2 == 1 and ball_area2 == 1:
		set_applied_force(-charge*E*Vector2(cos(angle_p2), sin(angle_p2)) + charge*B*Vector2(linear_velocity.y, -linear_velocity.x))
	elif magnetic_active == 1 and elec_att_active_p1 == 1 and ball_area1 == 1 and elec_att_active_p2 == 1 and ball_area2 == 1:
		set_applied_force(-charge*E*Vector2(cos(angle_p1), sin(angle_p1)) + charge*B*Vector2(linear_velocity.y, -linear_velocity.x) - charge*E*Vector2(cos(angle_p2), sin(angle_p2)))
	elif intro_force:
		set_applied_force(Vector2(-1,0))
	else:
		set_applied_force(Vector2(0, 0))

	if _velocity_normalization_needed:
		if linear_velocity.is_equal_approx(Vector2.ZERO):
			linear_velocity = _pad_normal * min_speed
		elif linear_velocity.length() < min_speed:
			linear_velocity = linear_velocity.normalized() * min_speed
		_velocity_normalization_needed = false

func set_sprite():
	if (charge >= 0):
		$Sprite.animation = "positive"
	else :
		$Sprite.animation = "negative"

func change_polarity():
	print_debug("Polarity changed")
	charge *= -1
	set_sprite()
	$Trail.set_gradient(charge)
	playPowerupSound()

func _on_Pause_between_rounds_timeout() -> void:
	_velocity_reset_needed = true
	$Trail.start()

func execute_magnetic():
	magnetic_active = 1
	print_debug("Magnetic field active")
	$Magnetic_Timer.start()
	playPowerupSound()

func _on_Magnetic_Timer_timeout():
	$Magnetic_Timer.stop()
	print_debug("Magnetic field stops")
	magnetic_active = 0


func _on_Ball_body_entered(body):
	if body.is_in_group("players"):
		last_hit_player = body
		_velocity_normalization_needed = true
		_pad_normal = (center_of_screen - body.position).normalized()

func get_last_hit_player() -> Player:
	return last_hit_player


func _on_Area2D_body_entered(body):
	if body.is_in_group("players"):
		$SoundBoing.play()


func playPowerupSound():
	$SoundPowerup.play()

func playPointSound():
	$SoundPoint.play()

func intro_elec_exec():
	intro_force = true
