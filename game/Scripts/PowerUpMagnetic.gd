extends Area2D

signal taken_magnetic

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_PowerUpMagnetic_body_entered(body):
	hide()
	emit_signal("taken_magnetic")
	$CollisionShape2D.set_deferred("disabled", true)

