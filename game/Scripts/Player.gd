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
export var ring_radius: float
var score := 0 setget , get_score
var manual_pos = false
var is_stopped: bool = false
export var speed_multiplied = 1.2

# Multi-player variable
onready var old_position
onready var new_position
onready var network_timer = $NetworkTimer


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
	if  MultiVariables.is_multi && is_network_master():
		network_timer.start()
		MultiVariables.player_num = player
	old_position = position
	new_position = position


func position_from_angle(alpha: float) -> Vector2:
	return ring_center + ring_radius * Vector2(cos(alpha), sin(alpha))


func _input(event):
	if is_input_sensitive && ((not MultiVariables.is_multi) || is_network_master()):
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


# Update position
puppet func up(_new_position):
	old_position = new_position
	new_position = _new_position
	position = _new_position


func _on_NetworkTimer_timeout():
	rpc_unreliable("up", position)


func _physics_process(delta: float) -> void:
	if not MultiVariables.is_multi || is_network_master(): 
		var relative_pos := position - ring_center
		var tangent := Vector2(-relative_pos.y, relative_pos.x).normalized()
		var movement := Vector2.ZERO
		if is_input_sensitive and !is_stopped:
			if is_clockwise:
				movement = movement + angle_step * ring_radius * delta * tangent * speed_multiplied
			if is_trigo:
				movement = movement - angle_step * ring_radius * delta * tangent * speed_multiplied

		var _collision := move_and_collide(movement)
		relative_pos = position - ring_center
		angle = relative_pos.angle()
		if not manual_pos:
			position = ring_center + relative_pos.normalized() * ring_radius
			rotation = angle + PI/2
	else:
		position += (new_position-old_position) * (delta / network_timer.wait_time)
		var relative_pos := position - ring_center
		angle = relative_pos.angle()
		position = position_from_angle(angle)
		rotation = angle + PI/2


func increment_score():
	score += 1
	if score >= MAX_SCORE:
		emit_signal("player_won", player)

func get_score():
	return score

func stop_moving():
	is_stopped = true


func start_moving():
	is_stopped = false

