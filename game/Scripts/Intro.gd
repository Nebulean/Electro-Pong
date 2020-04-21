extends Node

var text
var ball
var ball_scn
var textIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# We load the text file that will guide the tutorial
	text = load_text("res://Assets/Text/intro.txt")
	
	# We instanciate a ball
	ball_scn = preload("res://Scenes/Ball.tscn")
	ball = ball_scn.instance()
	var pos = Vector2(get_viewport().size.x/2, get_viewport().size.y/2)
	var vel = Vector2(0,0)
	ball_modifier(pos, vel)
	ball.set_visible(false)

# warning-ignore:unused_argument
func _physics_process(delta):
	# we check if the ball is off limite
	if ball.position.x < 0:
		ball.linear_velocity.x *= -1
	if ball.position.x > get_viewport().size.x:
		ball.linear_velocity.x *= -1
	if ball.position.y < 0:
		ball.linear_velocity.y *= -1
	if ball.position.y > get_viewport().size.y:
		ball.linear_velocity.y *= -1

func _input(ev):
	# We check if any key is pressed
	if ev is InputEventKey and ev.pressed:
		textIndex += 1
		
		# If we are at the end of the file, we go to next scene
		if textIndex >= text.size():
			get_tree().change_scene("res://Scenes/Gameplay.tscn")
		else:
			next_content(textIndex)

# Will handle what append when next line
func next_content(index):
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
func load_text(filename):
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
func line_interpreter(line):
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

func ball_modifier(position, velocity):
	# We remove the previous ball
	ball.queue_free()
	ball = ball_scn.instance()
	
	# We modify our properties
	ball.manual_state = true
	ball.set_position(position)
	ball.set_linear_velocity(velocity)
	ball.set_visible(true)
	
	# We add ball as scene child
	add_child(ball)
	

func command_interpreter(command):	
	if command == "EMPTY":
		print_debug("No commands here")
	elif command == "BALL_APPEAR_CENTER_STOP":
		var pos = Vector2(get_viewport().size.x/2, get_viewport().size.y/2)
		var vec = Vector2(0,0)
		ball_modifier(pos, vec)
	elif command == "BALL_DISAPPEAR":
		ball.set_visible(false)
	elif command == "PLAYER_APPEAR_BOTTOM":
		pass
	elif command == "BALL_APPEAR_LEFT_MOVE":
		var pos = Vector2(get_viewport().size.x/6, get_viewport().size.y/2)
		var vec = Vector2(200,0)
		ball_modifier(pos, vec)
	elif command == "PLAYER_DISAPPEAR":
		pass
	elif command == "MAGNETIC":
		pass
	else:
		print_debug("Unknown command")
