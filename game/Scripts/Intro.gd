extends Node2D

var text
var ball_scn
var ball

var textIndex = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# We load the scenes
	ball_scn = preload("res://Scenes/Ball.tscn")

	# We instanciate a scenes
	ball = ball_scn.instance()

	# We load the text file that will guide the tutorial
	text = load_text("res://Assets/Text/intro.txt")

func _input(ev):
	# We check if any key is pressed
	if ev is InputEventKey and ev.pressed:
		textIndex += 1
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

	# We update the text
	# TODO : THE FADE DO NOT WORK
	# for i in range(100, 0):
	# 	$Label.modulate = i

	# $Label.add_color_override("font_color", Color("#ffffff")) # does not work
	$Label.text = line


	# for i in range(0, 100):
	# 	$Label.modulate = i


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


func command_interpreter(command):
	if command == "EMPTY":
		print("No commands here")
		
	elif command == "BALL_CREATE":
		print("Creating ball")
		# We add the ball to child
		add_child(ball)
		
		# We select a position for the ball
		var pos = Vector2(get_viewport().size.x/10, get_viewport().size.y/2)
		ball.position = pos
		
	elif command == "BALL_MOVE":
		# We select a velocity for the ball
		var vel = Vector2(100, 0)
		ball.linear_velocity = vel
		
	elif command == "BALL_DISAPPEAR":
		# We hide the ball
		ball.hide()
		
	else:
		print("Unknown command")
