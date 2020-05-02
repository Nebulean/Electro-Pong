extends Node

onready var ring := $Ring
onready var p1 := $Player1
onready var p2 := $Player2
onready var ball := $Ball
onready var area1 := $AreaElectric1
onready var area2 := $AreaElectric2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set ring
	var screen_size := get_tree().root.size
	ring.position = screen_size/2
	var radius := ($Ring/CollisionShape2D.shape as CircleShape2D).radius
	
	area1.position = screen_size/2
	area2.position = screen_size/2
	
	# Set players
	p1.set_player(1, ring.position, radius)
	p2.set_player(2, ring.position, radius)
	#p1.add_collision_exception_with(p2)
	#p2.add_collision_exception_with(p1)

# The angles must be between 0 and 2*PI
func angular_distance(alpha: float, beta: float) -> float:
	assert(0 <= alpha && alpha <= 2*PI)
	assert(0 <= beta && beta <= 2*PI)
	if alpha > beta:
		var temp := alpha
		alpha = beta
		beta = temp

	var diff := beta - alpha
	return min(diff, 2*PI - diff)

func _physics_process(_delta: float) -> void:
	# Ring rotation
	var first_solution: float = (p1.angle + p2.angle)/2
	var dist_to_first_solution := angular_distance(first_solution, ring.angle)
	var second_solution := wrapf(first_solution + PI, 0, 2*PI)
	var dist_to_second_solution := angular_distance(second_solution, ring.angle)
	if dist_to_first_solution < dist_to_second_solution:
		ring.angle = first_solution
	else:
		ring.angle = second_solution
	#Area for electric field rotation with player
	area1.angle = p1.angle
	area2.angle = p2.angle
	ball.angle_p1 = p1.angle
	ball.angle_p2 = p2.angle

func execute_elec_att(num):
	assert(num in [1, 2])
	if num == 1:
		ball.elec_att_active_p1 = 1
		$ElecAttTimer1.start()
	else:
		ball.elec_att_active_p2 = 1
		$ElecAttTimer2.start()


func _on_AreaElectric1_body_entered(body):
	ball.ball_area1 = 1

func _on_AreaElectric1_body_exited(body):
	ball.ball_area1 = 0

func _on_AreaElectric2_body_entered(body):
	ball.ball_area2 = 1

func _on_AreaElectric2_body_exited(body):
	ball.ball_area2 = 0


func _on_ElecAttTimer1_timeout():
	$ElecAttTimer1.stop()
	print_debug("Attractive Electric field stopped for Player 1")
	ball.elec_att_active_p1 = 0

func _on_ElecAttTimer2_timeout():
	$ElecAttTimer2.stop()
	print_debug("Attractive Electric field stopped for Player 2")
	ball.elec_att_active_p2 = 0
