extends KinematicBody2D

var angle
var is_right = false
var is_left = false
export var angle_step = 1
var player

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

		
func set_player(new_player):
	player = new_player
	set_player_sprit()

func set_player_sprit():
	if player == 0:
		angle = 0
		$Sprite.animation = "player1"
	else:
		angle = PI
		$Sprite.animation = "player2"

func _input(event):
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
	if is_right:
		angle = angle + angle_step * delta
	if is_left:
		angle = angle - angle_step * delta
	position = Vector2(250, 0).rotated(angle)
	rotation_degrees

