extends Node

var text
var ball
var ball_scn
var textIndex = 0
var image
var ring
var ring_scn
var player1
var player2
var player_scn
var apple
var apple_scn
var pu_el
var pu_el_scn
var pu_mag
var pu_mag_scn
var pu_pol
var pu_pol_scn
onready var max_coordinates := Vector2(
	ProjectSettings.get_setting("display/window/size/width") as int,
	ProjectSettings.get_setting("display/window/size/height") as int
)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# We load the text file that will guide the tutorial
	text = load_text("res://Assets/Text/intro.txt")


	# We instanciate a ball
	ball_scn = preload("res://Scenes/Ball.tscn")
	ball = ball_scn.instance()
	var pos = Vector2(max_coordinates.x/2, max_coordinates.y/2)
	var vel = Vector2(0,0)
	ball_modifier(pos, vel)
	ball.set_visible(false)
	ball.get_node("Trail").start()

	# We create an empty image
	image = Sprite.new()

	# We preload some other scenes
	ring_scn = preload("res://Scenes/Ring.tscn")
	player_scn = preload("res://Scenes/Player.tscn")
	apple_scn = preload("res://Scenes/Apple.tscn")
	pu_el_scn = preload("res://Scenes/PowerUpElecAtt.tscn")
	pu_mag_scn = preload("res://Scenes/PowerUpMagnetic.tscn")
	pu_pol_scn = preload("res://Scenes/PowerUpPolarityInverter.tscn")

	# We hide some things
	$Ground.visible = false

	# We start the tutorial
	next_content(textIndex)
	textIndex += 1

func _physics_process(delta: float) -> void:
	# we check if the ball is off limite
	if ball.position.x < 0:
		ball.linear_velocity.x *= -1
	if ball.position.x > max_coordinates.x:
		ball.linear_velocity.x *= -1
	if ball.position.y < 0:
		ball.linear_velocity.y *= -1
	if ball.position.y > max_coordinates.y:
		ball.linear_velocity.y *= -1

func _input(ev: InputEvent) -> void:
	# We check if any key is pressed
	if ev is InputEventKey and ev.pressed:
		# If we are at the end of the file, we go to next scene
		if textIndex >= text.size():
			get_tree().change_scene("res://Scenes/Gameplay.tscn")
		else:
			next_content(textIndex)
		textIndex += 1

# Will handle what append when next line
func next_content(index: int) -> void:
	# We interprete the text
	var res = line_interpreter(text[index])
	var line = res[0]
	var cmd = res[1]

	# We take care of the command, if any
	var cmds = cmd.split(",")
	for c in cmds:
		command_interpreter(c)

	$Label.set_text(line)
	$Label.set_visible(true)

# This function will load a text file, and add each line to an element of an array.
func load_text(filename: String) -> String:
	# We create all our variables
	var txt = Array() # will contain all the texts
	var f = File.new() # will contain the file data

	# We open the file READONLY
	f.open(filename, File.READ)

	# We add each line to the array
	while not f.eof_reached():
		var line = f.get_line()
		txt.append(line)

	# When we finished, we close the file and return the data
	f.close()

	return txt


# This function will read the input string, and interpret it.
# All is considered text, except when !(THIS) is at the beginning of the string,
# which will be interpreted as a command.
func line_interpreter(line: String) -> Array:
	# We first check if we have any thing
	if not line.empty():
		if line[0] == "!" and line[1] == "(":
			# We now know there is a command in the string. We find the end of it.
			var end_index = line.find(")")

			assert(not (end_index == -1)) # Raise error if a end isn't found.

			var command = line.substr(2, end_index-2)
			# print("Command: " + command)

			var new_line = line.substr(end_index+2) # 1 for ")", 1 for " ".
			# print("Rest of the line: " + new_line)

			return [new_line, command]
	return [line, "EMPTY"]

func ball_modifier(position: Vector2, velocity: Vector2) -> void:
	# We remove the previous ball
	if is_instance_valid(ball):
		ball.queue_free()
	ball = ball_scn.instance()

	# We modify our properties
	ball.intro = true
	ball.set_position(position)
	ball.set_linear_velocity(velocity)
	ball.set_visible(true)
	ball.sleeping = false
	ball.intro = true
	ball.get_node("Trail").reset_trail()

	# We add ball as scene child
	add_child(ball)
	ball.get_node("Trail").start()


func load_image(path: String, pos: Vector2, scale: Vector2) -> void:
	# We free the previous image
	if is_instance_valid(image):
		image.queue_free()
	# We load the new one and we apply it
	var texture = load(path)
	image = Sprite.new()
	image.set_texture(texture)
	image.set_position(pos)
	image.set_scale(scale)
	add_child(image)

func execute_elec() -> void:
	ball.playPowerupSound()
	ball.intro_elec_exec()

func command_interpreter(command: String) -> void:
	if command == "EMPTY":
		print_debug("No commands here")
	elif command == "BALL_APPEAR_CENTER_STOP":
		var pos = Vector2(max_coordinates.x/2, max_coordinates.y/2)
		var vec = Vector2(0,0)
		ball_modifier(pos, vec)
		# ball.startTrail()
	elif command == "BALL_DISAPPEAR":
		# ball.stopTrail()
		ball.set_visible(false)
		ball.sleeping = true
		ball.linear_velocity = Vector2.ZERO
		ball.position = Vector2.ZERO

	elif command == "BALL_APPEAR_LEFT_MOVE":
		var pos = Vector2(max_coordinates.x/6, max_coordinates.y/2)
		var vec = Vector2(200,0)
		ball_modifier(pos, vec)
		# ball.startTrail()
	elif command == "MAGNETIC_APPEAR":
		pu_mag = pu_mag_scn.instance()
		var pos = Vector2(max_coordinates.x/2, max_coordinates.y/2)
		pu_mag.set_position(pos)
		pu_mag.connect("taken_magnetic", ball, "execute_magnetic")
		add_child(pu_mag)
	elif command == "MAGNETIC_DISAPPEAR":
		if is_instance_valid(pu_mag):
			pu_mag.disconnect("taken_magnetic", ball, "execute_magnetic")
			pu_mag.queue_free()
	elif command == "ELECTRIC_APPEAR":
		# We spawn the electric powerup
		pu_el = pu_el_scn.instance()
		var pos = Vector2(max_coordinates.x/3, max_coordinates.y/2)
		pu_el.set_position(pos)
		pu_el.connect("taken_elec_att", self, "execute_elec")
		# We spawn the player
		player1 = player_scn.instance()
		var posP = Vector2(2*max_coordinates.x/3, max_coordinates.y/2)
		player1.set_position(posP)
		player1.set_rotation(PI/2)
		player1.manual_pos = true
		add_child(pu_el)
		add_child(player1)
	elif command == "ELECTRIC_DISAPPEAR":
		if is_instance_valid(pu_el):
			pu_el.queue_free()
		if is_instance_valid(player1):
			player1.queue_free()
	elif command == "PLAYER_1_KEYBOARD_APPEAR":
		var pos = Vector2(max_coordinates.x/2, max_coordinates.y/2)
		var scale = Vector2(4, 4)
		load_image("res://Assets/Sprites/player_1_key.png", pos, scale)
	elif command == "PLAYER_2_KEYBOARD_APPEAR":
		var pos = Vector2(max_coordinates.x/2, max_coordinates.y/2)
		var scale = Vector2(4, 4)
		load_image("res://Assets/Sprites/player_2_key.png", pos, scale)
	elif command == "IMAGE_CLEAR":
		load_image("", Vector2(0,0), Vector2(0,0))
	elif command == "RING_APPEAR":
		# We spawn the ring
		ring = ring_scn.instance()
		var pos = Vector2(max_coordinates.x/2, max_coordinates.y/2)
		var scale = Vector2(0.7, 0.7)
		ring.set_position(pos)
		ring.set_scale(scale)
		add_child(ring)
	elif command == "RING_DISSAPPEAR":
		if is_instance_valid(ring):
			ring.queue_free()
	elif command == "APPLE_APPEAR":
		# instanciate the apple
		apple = apple_scn.instance()
		var pos = Vector2(max_coordinates.x/2, max_coordinates.y/4)
		apple.set_position(pos)
		# We show the ground
		$Ground.visible = true
		# We add the apple to children
		add_child(apple)
	elif command == "APPLE_DISAPPEAR":
		if is_instance_valid(apple):
			apple.queue_free()
		if is_instance_valid($Ground):
			$Ground.queue_free()
	elif command == "POWERUPS_APPEAR":
		# We spawn all powerups
		pu_el = pu_el_scn.instance()
		pu_mag = pu_mag_scn.instance()
		pu_pol = pu_pol_scn.instance()
		var pos_el = Vector2(3*max_coordinates.x/8, max_coordinates.y/2)
		var pos_mag = Vector2(max_coordinates.x/2, max_coordinates.y/2)
		var pos_pol = Vector2(5*max_coordinates.x/8, max_coordinates.y/2)
		pu_el.set_position(pos_el)
		pu_mag.set_position(pos_mag)
		pu_pol.set_position(pos_pol)
		add_child(pu_el)
		add_child(pu_mag)
		add_child(pu_pol)
	elif command == "POWERUPS_DISAPPEAR":
		if is_instance_valid(pu_el):
			pu_el.queue_free()
		if is_instance_valid(pu_mag):
			pu_mag.queue_free()
		if is_instance_valid(pu_pol):
			pu_pol.queue_free()
	elif command == "VECTORFIELD_APPEAR":
		# useless and ugly
		pass
		#var pos = Vector2(max_coordinates.x/2, max_coordinates.y/2)
		#var scale = Vector2(0.4, 0.4)
		#load_image("res://Assets/Sprites/vector_field.png", pos, scale)
	else:
		print_debug("Unknown command")
