extends KinematicBody2D

class_name Player

var angle
var is_right = false
var is_left = false
export var angle_step = 1
export var is_input_sensitive = true
var player
var ring_center: Vector2
var ring_radius: float

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
	set_position_via_angle()

func set_position_via_angle() -> void:
	position = ring_center + ring_radius*Vector2(cos(angle), sin(angle))

func _input(event):
	if is_input_sensitive:
		if event.is_action_pressed("ui_right") && player == 1:
			is_right = true
		if event.is_action_pressed("ui_right2") && player == 2:
			is_right = true
		if event.is_action_pressed("ui_left") && player == 1:
			is_left = true
		if event.is_action_pressed("ui_left2") && player == 2:
			is_left = true
		if event.is_action_released("ui_right") && player == 1:
			is_right = false
		if event.is_action_released("ui_right2") && player == 2:
			is_right = false
		if event.is_action_released("ui_left") && player == 1:
			is_left = false
		if event.is_action_released("ui_left2") && player == 2:
			is_left = false

func _physics_process(delta):
	var lastPos = Vector2(0, 250).rotated(angle)
	var lastAngle = angle
	if is_right:
		angle = angle + angle_step * delta
	if is_left:
		angle = angle - angle_step * delta
	set_position_via_angle()
