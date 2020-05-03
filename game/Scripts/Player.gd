extends KinematicBody2D

class_name Player

const MAX_SCORE = 11
export var angle: float
var is_clockwise = false
var is_trigo = false
export var angle_step = 1
export var is_input_sensitive = true
var player
var ring_center: Vector2
var ring_radius: float
var score := 0 setget , get_score
var is_ready_to_collide
var is_colliding_with_player = false
var was_trigo = false
var was_clockwise = false
signal player_won(player)


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
	
	if !is_colliding_with_player:
		if is_clockwise:
			angle = wrapf(angle + angle_step * delta, 0, 2*PI)
		if is_trigo:
			angle = wrapf(angle - angle_step * delta, 0, 2*PI)
	else:
		if is_clockwise and !was_clockwise:
			angle = wrapf(angle + angle_step * delta, 0, 2*PI)
		if is_trigo and !was_trigo:
			angle = wrapf(angle - angle_step * delta, 0, 2*PI)


	position = position_from_angle(angle)
	rotation = angle + PI/2

func increment_score():
	score += 1
	if score >= MAX_SCORE:
		emit_signal("player_won", player)

func get_score():
	return score

# This will detect the collision between the player and other stuff.
# If it collides with another player, they will be blocked.
func _on_Area2D_body_entered(body):
	# if only one of the keys is pressed
	if (!is_colliding_with_player and (is_clockwise and !is_trigo) or (!is_clockwise and is_trigo)):
		get_tree().call_group("players", "tell_colliding", body, is_clockwise, is_trigo, player)

func tell_colliding(body, is_cw, is_tr, source):
	if source == player:
		was_clockwise = is_cw
		was_trigo = is_tr
	else:
		was_clockwise = !is_cw
		was_trigo = !is_tr
	if body.is_in_group("players") and is_ready_to_collide:
		is_colliding_with_player = true
		print_debug("The two players are colliding.")

func _on_Area2D_body_exited(body):
	get_tree().call_group("players", "tell_colliding", body)
	was_clockwise = is_clockwise
	was_trigo = is_trigo
	if body.is_in_group("players"):
		is_colliding_with_player = false

# simple timer initial pour éviter la collision initiale qui va bloquer les joueurs.
func _on_Timer_timeout():
	is_ready_to_collide = true # Replace with function body.
