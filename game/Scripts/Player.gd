extends KinematicBody2D

class_name Player

export var angle: float
var is_clockwise = false
var is_trigo = false
export var angle_step = 1
export var is_input_sensitive = true
var player
var ring_center: Vector2
var ring_radius: float
var score := 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_player(num: int, center: Vector2, radius: float):
	assert(num in [1, 2])
	player = num
	if player == 1:
		angle = PI/2
		$Sprite.animation = "player1"
	else:
		angle = 3*PI/2
		$Sprite.animation = "player2"

	ring_center = center
	ring_radius = radius
	position = position_from_angle(angle)

func position_from_angle(alpha: float) -> Vector2:
	return ring_center + ring_radius * Vector2(cos(alpha), sin(alpha))

func _input(event):
	if is_input_sensitive:
		if event.is_action_pressed("p1_clockwise") && player == 1:
			is_clockwise = true
		if event.is_action_pressed("p2_clockwise") && player == 2:
			is_clockwise = true
		if event.is_action_pressed("p1_trigo") && player == 1:
			is_trigo = true
		if event.is_action_pressed("p2_trigo") && player == 2:
			is_trigo = true
		if event.is_action_released("p1_clockwise") && player == 1:
			is_clockwise = false
		if event.is_action_released("p2_clockwise") && player == 2:
			is_clockwise = false
		if event.is_action_released("p1_trigo") && player == 1:
			is_trigo = false
		if event.is_action_released("p2_trigo") && player == 2:
			is_trigo = false

func _physics_process(delta):
	var lastAngle = angle
	if is_clockwise:
		angle = wrapf(angle + angle_step * delta, 0, 2*PI)
	if is_trigo:
		angle = wrapf(angle - angle_step * delta, 0, 2*PI)
	position = position_from_angle(angle)
	rotation = angle + PI/2
