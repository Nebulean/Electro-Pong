extends Node2D

var current # stores the current powerup (empty initially)
enum {MAGNETIC, POLARITY, ELECTRO_OUT, ELECTRO_IN} # powerups type names
var mag
var pol
var el_out
var el_in

func _ready():
	pass
	# mag		= preload("res://Scenes/")
	# pol		= preload("res://Scenes")
	# el_out		= preload("res://Scenes/")
	# el_in		= preload("res://Scenes")
	
func spawn(type):
	if not current.empty:
		pass
	if type == MAGNETIC:
		pass
	if type == POLARITY:
		pass
	if type == ELECTRO_OUT:
		pass
	if type == ELECTRO_IN:
		pass
