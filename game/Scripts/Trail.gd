extends Line2D

var target
var point
var trail_active = false
export (NodePath) var target_path
export var trail_length = 0
export (Gradient) var positive_gradient
export (Gradient) var negative_gradient
# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(target_path)
	#set_gradient(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not trail_active:
		return
	
	global_position = Vector2(0,0)
	global_rotation = 0
	point = target.global_position
	add_point(point)
	
	while get_point_count() > trail_length:
		# remove the oldest point (at the end of the trail)
		remove_point(0)

func reset_trail() -> void:
	trail_active = false
	clear_points()

func start() -> void:
	trail_active = true
	
func set_gradient(charge) -> void:
	if (charge >= 0):
		gradient = positive_gradient
	else:
		gradient = negative_gradient
