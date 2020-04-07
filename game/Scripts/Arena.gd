extends Area2D

export var arena_size = 1000
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen = get_viewport_rect().size
	position.x = screen.x/2
	position.y = screen.y/2
	$Player1.set_player(1)
	$Player2.set_player(2)
	$Player1.add_collision_exception_with($Player2)
	$Player2.add_collision_exception_with($Player1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
