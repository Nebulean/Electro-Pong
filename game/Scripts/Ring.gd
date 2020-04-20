extends Area2D

class_name Ring

var angle: float = 0

func _physics_process(_delta: float) -> void:
	set_rotation(angle)
