extends Node2D

var current # stores the current powerup (empty initially)
enum {MAGNETIC, POLARITY, ELECTRO_OUT, ELECTRO_IN} # powerups type names
var mag_scn
var pol_scn
var el_out_scn
var el_in_scn

func _ready():
	pass
	# mag_scn		= preload("res://Scenes/")
	# pol_scn		= preload("res://Scenes")
	# el_out_scn		= preload("res://Scenes/")
	# el_in_scn		= preload("res://Scenes")
	
func spawn(type):
	# We remove the previous powerup
	if not current.empty:
		current.queue_free()
	# And we add the new one.
	if type == MAGNETIC:
		current = mag_scn.instance()
	elif type == POLARITY:
		current = pol_scn.instance()
	elif type == ELECTRO_OUT:
		current = el_out_scn.instance()
	elif type == ELECTRO_IN:
		current = el_in_scn.instance()
	else:
		print_debug("This is not a valid powerup type.")
	
	# We disable the powerup (it's just there, nothing more).
		
	# We add the new powerup to the storage
	add_child(current)

func execute_powerup():
	#current.
	pass
