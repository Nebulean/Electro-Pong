extends Area2D

signal taken_polarity_inverter

func _on_PowerUpPolarityInverter_body_entered(body):
	hide()
	emit_signal("taken_polarity_inverter")
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()
