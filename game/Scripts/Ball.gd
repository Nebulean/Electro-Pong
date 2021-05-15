extends RigidBody2D

class_name Ball

onready var center_of_screen := get_viewport_rect().size/2
export var min_speed: float = 150
export var max_speed: float= 200
export var charge: float = 1
var _position_reset_needed := false
var _velocity_reset_needed := false
remotesync var _pad_normal: Vector2
remotesync var _velocity_normalization_needed := false
var magnetic_active = 0
var elec_att_active_p1 = 0
var elec_att_active_p2 = 0
var ball_area1 = 0
var ball_area2 = 0
var angle_p1
var angle_p2
export var B = 0.01
export var E = 2.1
var last_hit_player: Player = null
var exploding = false
var intro = false
var intro_force = false

# Multi-player variable
var ball_velocity = Vector2.ZERO
var sync_needed = false
# Number of remaining frame where sync function have to been called:
var frame_sync = 0
# Number of frame where sync function is called:
var FRAME_SYNC_MAX = 40
# Id of the frame send:
var id_frame_sync = 0
# Last id receive from the other player:
var last_remote_id_frame = -1
# Id of the synchronization. Change when a player hit the ball.
var id_sync = 0
var sync_last_hit_needed = false


func _ready():
	set_sprite()
	mode = MODE_CHARACTER
	_update_velocity()
	if !intro:
		can_sleep = false
		contact_monitor = true
		contacts_reported = 1
		_on_Sprite_animation_finished()
		$Trail.start()


func reset():
	$Trail.reset_trail()
	set_linear_velocity(Vector2.ZERO)
	if charge > 0:
		$Sprite.play("positive_explode")
	else:
		$Sprite.play("negative_explode")
	exploding = true
	if get_tree():
		get_tree().call_group("players", "stop_moving")


func _new_random_velocity() -> Vector2:
	var new_velocity := Vector2(1, 0)
	var direction := rand_range(-PI, PI)
	new_velocity = new_velocity.rotated(direction) * rand_range(min_speed, max_speed)
	return new_velocity


func _update_velocity() -> void:
	if not MultiVariables.is_multi:
		ball_velocity = _new_random_velocity()
	elif is_network_master():
		ball_velocity = _new_random_velocity()
		rpc("sv", ball_velocity)


puppet func sv(velocity): # Set velocity
	ball_velocity = velocity


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
		exploding = false
		get_tree().call_group("players", "start_moving")
	if _velocity_reset_needed:
		state.set_linear_velocity(ball_velocity)
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
	
	# Ball sync in multi
	if MultiVariables.is_multi:
		if frame_sync < FRAME_SYNC_MAX and sync_needed:
			frame_sync += 1
#			print_debug("Send sync")
			rpc_unreliable("sb", id_sync, frame_sync, position, linear_velocity)
		if sync_last_hit_needed:
			print_debug("Send sync last_hit ", id_sync)
			rpc_unreliable("slh", id_sync, MultiVariables.player_num)

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
	get_tree().call_group("areaElectric", "update_sprite", charge)

func _on_Pause_between_rounds_timeout() -> void:
	_velocity_reset_needed = true
	sleeping = false
	show()
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
		if not MultiVariables.is_multi || body.is_network_master():
			last_hit_player = body
			_velocity_normalization_needed = true
			_pad_normal = (center_of_screen - body.position).normalized()
		if body.is_network_master():
			frame_sync = 0
			sync_needed = true
			sync_last_hit_needed = true
			id_sync += 1
			print_debug("Sync id: ", id_sync)
			rpc_unreliable("slh", id_sync, MultiVariables.player_num)


remote func sb(remote_id_sync, remote_id_frame, _position, _velocity): # Sync ball
	if remote_id_sync > id_sync:
		last_remote_id_frame = -1
		id_sync = remote_id_sync
		print_debug("Change id_frame")
	if remote_id_sync == id_sync and last_remote_id_frame < remote_id_frame:
		position = _position
		linear_velocity = _velocity
		last_remote_id_frame = remote_id_frame
	elif remote_id_sync == id_sync:
		print_debug("Receive outdated ball sync (late)")
	else:
		print_debug("Receive outdated ball sync (not the right id_sync)")


remote func slh(new_id_sync, _player_num): # Set last_hit_player
	if new_id_sync > id_sync:
		print_debug("Receive sync ", new_id_sync, " currently ", id_sync, " -> update")
		id_sync = new_id_sync
		last_hit_player = MultiVariables.players[_player_num-1]
		frame_sync = 0
		last_remote_id_frame = -1
		sync_needed = false
		print_debug("Change id_frame")
	else:
		print_debug("Receive sync ", new_id_sync, " currently ", id_sync, " -> ignore")
	if new_id_sync <= id_sync:
		rpc_unreliable("conf_slh", id_sync)


remote func conf_slh(new_id_sync):
	if new_id_sync >= id_sync:
		print_debug("Stop sync last_hit ", id_sync)
		sync_last_hit_needed = false


#remote func sp(_position, _linear_velocity): # Sync position (and speed)
#	if last_hit_player != MultiVariables.players[MultiVariables.player_num-1]:
#		position = _linear_velocity
#		linear_velocity = _linear_velocity


func get_last_hit_player() -> Player:
	return last_hit_player


func _on_Area2D_body_entered(body):
	if body.is_in_group("players") and not exploding:
		$SoundBoing.play()

func playPowerupSound():
	$SoundPowerup.play()

func playPointSound():
	$SoundPoint.play()

func intro_elec_exec():
	intro_force = true

func _on_Sprite_animation_finished():
	$Sprite.stop()
	hide()
	$Reset_timer.start()
	print_debug("coucous")
	_position_reset_needed = true
	$Pause_between_rounds.start()
	_update_velocity()


func _on_Reset_timer_timeout():
	show()
	$Reset_timer.stop()
