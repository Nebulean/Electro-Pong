extends Area2D

var angle: float = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(_delta: float) -> void:
	set_rotation(angle)

func set_sprite(value : bool):
	if value:
		$AreaSprite.show()
	else:
		$AreaSprite.hide()
