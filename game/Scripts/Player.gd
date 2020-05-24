extends KinematicBody2D

class_name Player

const MAX_SCORE = 11
var angle: float
var is_clockwise = false
var is_trigo = false
export var angle_step: float = 1
export var is_input_sensitive = true
var player
var ring_center: Vector2
var ring_radius: float
var score := 0 setget , get_score
var manual_pos = false

signal player_won(player)

func set_player(num: int, center: Vector2, radius: float):
	assert(num in [1, 2])
	player = num
	if player == 1:
		angle = PI/2
		$Sprite.animation = "player1"
	else:
		angle = -PI/2
		$Sprite.animation = "player2"

	ring_center = center
	ring_radius = radius
	if not manual_pos:
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
	else:
		is_clockwise = false
		is_trigo = false

func _physics_process(delta: float) -> void:
	var relative_pos := position - ring_center
	var tangent := Vector2(-relative_pos.y, relative_pos.x).normalized()
	var movement := Vector2.ZERO
	if is_input_sensitive:
		if is_clockwise:
			movement = movement + angle_step * ring_radius * delta * tangent
		if is_trigo:
			movement = movement - angle_step * ring_radius * delta * tangent

	var _collision := move_and_collide(movement)
	relative_pos = position - ring_center
	angle = relative_pos.angle()
	if not manual_pos:
		position = ring_center + relative_pos.normalized() * ring_radius
		rotation = angle + PI/2

func increment_score():
	score += 1
	if score >= MAX_SCORE:
		emit_signal("player_won", player)

func get_score():
	return score

func stop_moving():
	is_input_sensitive = false

func start_moving():
	is_input_sensitive = true
