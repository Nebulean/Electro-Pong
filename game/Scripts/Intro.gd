extends Node2D

var text

# Called when the node enters the scene tree for the first time.
func _ready():
	# We load the ball scene
	var ball_scn = preload("res://Scenes/Ball.tscn")
	
	# We instanciate a ball
	var ball = ball_scn.instance()
	
	# We add the ball to child
	add_child(ball)
	
	# We select a position for the ball
	var pos = Vector2(get_viewport().size.x/10, get_viewport().size.y/2)
	ball.position = pos
	
	# We select a velocity for the ball
	var vel = Vector2(50, 0)
	ball.linear_velocity = vel
	
	# We load the text file that will guide the tutorial
	text = load_text("res://Assets/Text/intro.txt")




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
func line_interpreter(string):
	pass
