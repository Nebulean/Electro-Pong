extends Node

onready var ring := $Ring
onready var p1 := $Player1
onready var p2 := $Player2
onready var ball := $Ball

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set ring
	var screen_size := get_tree().root.size
	ring.position = screen_size/2
	var radius := ($Ring/CollisionShape2D.shape as CircleShape2D).radius
	
	# Set players
	p1.set_player(1, ring.position, radius)
	p2.set_player(2, ring.position, radius)
	p1.add_collision_exception_with(p2)
	p2.add_collision_exception_with(p1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
