extends Node

onready var ring := $Ring
onready var p1 := $Player1
onready var p2 := $Player2
onready var ball := $Ball
onready var hud := $HUD
onready var area1 := $AreaElectric1
onready var area2 := $AreaElectric2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set ring
	var radius := ($Ring/CollisionShape2D.shape as CircleShape2D).radius
	
	# Set players
	p1.set_player(1, ring.position, radius)
	p2.set_player(2, ring.position, radius)
	#p1.add_collision_exception_with(p2)
	#p2.add_collision_exception_with(p1)
	hud._on_game_starts()

# The angles must use the same bounds
func angular_distance(alpha: float, beta: float) -> float:
	assert(-PI <= alpha && alpha <= PI)
	assert(-PI <= beta && beta <= PI)
	var diff := abs(beta - alpha)
	return min(diff, 2*PI - diff)

func _physics_process(_delta: float) -> void:
	if not ball.exploding:
		# Ring rotation
		var first_solution: float = (p1.angle + p2.angle)/2
		var dist_to_first_solution := angular_distance(first_solution, ring.angle)
		var second_solution := wrapf(first_solution + PI, -PI, PI)
		var dist_to_second_solution := angular_distance(second_solution, ring.angle)
		if dist_to_first_solution < dist_to_second_solution:
			ring.angle = first_solution
		else:
			ring.angle = second_solution
		#Area for electric field rotation with player
		area1.angle = p1.angle - PI/2
		area2.angle = p2.angle - PI/2
		ball.angle_p1 = p1.angle
		ball.angle_p2 = p2.angle

func _on_Ring_body_exited(_body: Node) -> void:
	var exit_angle: float = (ball.position - ring.position).angle() - ring.angle
	exit_angle = wrapf(exit_angle, 0, 2*PI)
	if 0 <= exit_angle && exit_angle < PI:
		p2.increment_score()
		hud.set_score_p2(p2.score)
	else:
		p1.increment_score()
		hud.set_score_p1(p1.score)
	$Ball.playPointSound()
	if (p1.score < 11 && p2.score < 11):
		ball.reset()
	if ball.magnetic_active == 1:
		$Ball/Magnetic_Timer.stop()
		print_debug("Magnetic field stops")
		ball.magnetic_active = 0
	if ball.elec_att_active_p1 == 1:
		$ElecAttTimer1.stop()
		area1.set_sprite(false)
		print_debug("Attractive Electric field stopped for Player 1")
		ball.elec_att_active_p1 = 0
	if ball.elec_att_active_p2 == 1:
		$ElecAttTimer2.stop()
		area2.set_sprite(false)
		print_debug("Attractive Electric field stopped for Player 2")
		ball.elec_att_active_p2 = 0


func _on_player_won(player) -> void:
	assert(player in [1, 2])
	print_debug("Player %d won." % player)
	hud._on_player_won(player)
	$GameFinished.start()
	
func _on_GameFinished_timeout():
	var status := get_tree().change_scene("res://Scenes/MainMenu.tscn")
	assert(status == OK)

func execute_elec_att(num):
	$Ball.playPowerupSound()
	assert(num in [1, 2])
	if num == 1:
		print_debug("Electric field active for Player1")
		ball.elec_att_active_p1 = 1
		$ElecAttTimer1.start()
		area1.set_sprite(true)
	else:
		ball.elec_att_active_p2 = 1
		print_debug("Electric field active for Player2")
		$ElecAttTimer2.start()
		area2.set_sprite(true)


func _on_AreaElectric1_body_entered(body):
	if body.is_in_group("balls"):
		ball.ball_area1 = 1

func _on_AreaElectric1_body_exited(body):
	if body.is_in_group("balls"):
		ball.ball_area1 = 0

func _on_AreaElectric2_body_entered(body):
	if body.is_in_group("balls"):
		ball.ball_area2 = 1

func _on_AreaElectric2_body_exited(body):
	if body.is_in_group("balls"):
		ball.ball_area2 = 0


func _on_ElecAttTimer1_timeout():
	$ElecAttTimer1.stop()
	area1.set_sprite(false)
	print_debug("Attractive Electric field stopped for Player 1")
	ball.elec_att_active_p1 = 0

func _on_ElecAttTimer2_timeout():
	$ElecAttTimer2.stop()
	area2.set_sprite(false)
	print_debug("Attractive Electric field stopped for Player 2")
	ball.elec_att_active_p2 = 0


func _on_PowerupGenerator_taken_magnetic():
	ball.execute_magnetic()


func _on_PowerupGenerator_taken_elec_att():
	var p = ball.get_last_hit_player()
	if (p != null):
		var num = p.player
		execute_elec_att(num)
