extends Area2D

signal taken_magnetic

func _on_PowerUpMagnetic_body_entered(body):
	hide()
	emit_signal("taken_magnetic")
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()
